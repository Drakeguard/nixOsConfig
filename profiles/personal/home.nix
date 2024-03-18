{ config, pkgs, userSettings, systemSettings, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/app/powerlevel10k
    ../../user/app/git
    ../../user/app/terminal/alacritty.nix
    ../../user/app/keychain
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.


  home.packages = with pkgs; [
    # Core
    alacritty
    librewolf
    brave
    dmenu
    rofi
    git
    syncthing

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

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      #theme = "robbyrussell";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  fonts.fontconfig.enable = true;

  programs.gh = {
    enable = true;
  };

}
