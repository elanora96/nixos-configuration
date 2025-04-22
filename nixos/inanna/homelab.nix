{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab;
in
{
  imports = [ ./traefik.nix ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";
    domain = lib.mkOption {
      type = lib.types.str;
    };
    storage = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/media";
    };
  };

  config = lib.mkIf cfg.enable {
    homelab.traefik = {
      enable = true;
      services = {
        plex.port = 32400;
        jellyfin.port = 8096;
        sonarr.port = 8989;
        radarr.port = 7878;
        prowlarr.port = 9696;
      };
    };

    services = {
      plex = {
        enable = true;
        openFirewall = true;
        user = "el";
      };

      jellyfin = {
        enable = true;
        user = "el";
      };

      radarr = {
        enable = true;
        openFirewall = true;
        user = "el";
      };

      sonarr = {
        enable = true;
        openFirewall = true;
        user = "el";
      };

      prowlarr = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
