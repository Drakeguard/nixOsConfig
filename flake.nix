{
  description = "Flake of Drakeguard";

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nixos"; # hostname
        profile = "personal"; # select a profile defined from my profiles directory
        timezone = "Europe/Vienna"; # select timezone
        locale = "de_AT.UTF-8"; # select locale
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "arunm"; # username
        name = "Arun Maybusch"; # name/identifier
        email = "arun.maybusch@outlook.com"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      };


      # create patched nixpkgs
      nixpkgs-patched = (import nixpkgs { system = systemSettings.system; }).applyPatches {
        name = "nixpkgs-patched";
        src = nixpkgs;
        patches = [
          #./patches/emacs-no-version-check.patch
          #./patches/nixos-nixpkgs-268027.patch
        ];
      };

      # configure pkgs
      pkgs = import nixpkgs-patched {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        #overlays = [ rust-overlay.overlays.default ];
      };

      pkgs-stable = import nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        #overlays = [ rust-overlay.overlays.default ];
      };

      # configure lib
      lib = nixpkgs.lib;

    in
    {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
              inputs.nixvim.homeManagerModules.nixvim
            #  inputs.nix-flatpak.homeManagerModules.nix-flatpak # Declarative flatpaks
          ];
          extraSpecialArgs = {  inputs.nixvim.homeManagerModules.nixvim
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit (inputs) nixvim;
          };  inputs.nixvim.homeManagerModules.nixvim
        };
      };
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit (inputs) blocklist-hosts;
            inherit (inputs) nh;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs"; # override this repo's nixpkgs snapshot
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
}
