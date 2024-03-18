{ config, pkgs, userSettings, systemSettings, nixvim, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/powerlevel10k
    ../../user/app/git
    ../../user/app/terminal/zsh.nix
    ../../user/app/terminal/alacritty.nix
    ../../user/app/keychain
    ../../user/app/nixvim.nix
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Core
    alacritty
    librewolf
    brave
    dmenu
    rofi
    git
    syncthing
    neofetch

    # Media
    tuxpaint
    thefuck
    vscodium

    #fonts
    powerline-fonts
  ];

  xdg.enable = true;
  xdg.userDirs = {
    extraConfig = {
      XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
      XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
    };
  };
}
