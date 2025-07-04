{ ... }:
{
  imports = [ ../el/graphical.nix ];

  programs = {
    keychain = {
      enable = true;
      enableZshIntegration = true;
      keys = [
        "id_ed25519_el_inanna_2024-10-14"
        "id_ed25519_el_inanna_gh_2024-10-14"
      ];
    };
    obs-studio.enable = true;
    yt-dlp.enable = true;
  };

  home.stateVersion = "24.05"; # Leave it alone!
}
