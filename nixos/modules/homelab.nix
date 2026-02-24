{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab;
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
      #   # globalConfig = "skip_install_trust";

      #   virtualHosts = {
      #     "${cfg.domain}".extraConfig = ''
      #       reverse_proxy jellyfin.${cfg.domain} :8096
      #       reverse_proxy sonarr.${cfg.domain} :8989
      #       reverse_proxy radarr.${cfg.domain} :7878
      #       reverse_proxy prowlarr.${cfg.domain} :9696
      #       reverse_proxy lidarr.${cfg.domain} :8686
      #       # tls internal
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
