{ nh, userSettings, ... }:
{

  imports = [
    nh.nixosModules.default
  ];
  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1w --keep 5";
  };

  environment.variables = {
    FLAKE = "/home/" + userSettings.username + "/DEVELOP/NixOSConfig";
  };
}
