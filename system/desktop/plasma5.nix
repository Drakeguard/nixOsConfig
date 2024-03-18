{ ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "at";
    xkb.variant = "";
  };
}



