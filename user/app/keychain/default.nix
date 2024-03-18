{pkgs, ...}:
{
  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = [ "id_ed25519_github" ];
    package = pkgs.keychain;

  };
}
