{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab;

  # mkCaddyRule = subdomain: service: "reverse_proxy ${subdomain}.${cfg.domain} :${service.port}";
in
{
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
    environment.systemPackages = with pkgs; [
      qbittorrent-nox
    ];

    # security.acme = {
    #   acceptTerms = true;
    #   defaults = {
    #     email = "admin@${cfg.domain}";
    #     webroot = "/var/lib/acme/acme-challenge";
    #   };
    #   certs."${cfg.domain}" = {
    #     inherit (config.services.caddy) group;
    #     extraDomainNames = [
    #       "*.internal.${cfg.domain}"
    #     ];
    #   };
    # };

    services = {
      # keep-sorted start block=yes
      # caddy = {
      #   enable = true;
      #   virtualHosts = {
      #     "${cfg.domain}".extraConfig = ''
      #       ${mkCaddyRule "jellyfin" config.services.jellyfin}
      #       ${mkCaddyRule "sonarr" config.services.sonarr}
      #       ${mkCaddyRule "radarr" config.services.radarr}
      #       ${mkCaddyRule "prowlarr" config.services.prowlarr}
      #       ${mkCaddyRule "lidarr" config.services.lidarr}
      #     '';
      #   };
      # };
      jellyfin = {
        enable = true;
        openFirewall = true;
        user = "el";
      };
      lidarr = {
        enable = true;
        openFirewall = true;
        user = "el";
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
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
      # keep-sorted end
    };
  };
}
