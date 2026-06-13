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
