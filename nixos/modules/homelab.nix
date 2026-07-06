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

    networking.firewall.allowedTCPPorts =
      let
        acmePlainHTTPChallenge = 80;
        qbittorrent = 7470;
      in
      [
        acmePlainHTTPChallenge
        qbittorrent
      ];

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "admin@${cfg.domain}";
        webroot = "/var/lib/acme/acme-challenge";
      };
      certs."${cfg.domain}" = {
        inherit (config.services.nginx) group;
        extraDomainNames = [
          "*.${cfg.domain}"
        ];
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        forceSSL = true;
        useACMEHost = cfg.domain;
        acmeRoot = null;
        locations."/.well-known/".root = "/var/lib/acme/acme-challenge/";
      };
    };

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
