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
    sops.secrets = {
      # keep-sorted start block=yes
      "porkbun/api_key" = { };
      "porkbun/secret_api_key" = { };
      # keep-sorted end
    };

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
      defaults.email = "admin@${cfg.domain}";
      certs."${cfg.domain}" = {
        inherit (config.services.nginx) group;
        extraDomainNames = [
          "*.${cfg.domain}"
        ];
        dnsProvider = "porkbun";
        environmentFile = "${pkgs.writeText "porkbun-creds" ''
          PORKBUN_API_KEY_FILE=${config.sops.secrets."porkbun/api_key".path}
          PORKBUN_SECRET_API_KEY_FILE=${config.sops.secrets."porkbun/secret_api_key".path}
        ''}";
      };
    };

    services = {
      # keep-sorted start block=yes
      lidarr = {
        enable = true;
        openFirewall = true;
        user = "el";
      };
      nginx = {
        enable = true;
        virtualHosts.${cfg.domain} = {
          forceSSL = true;
          useACMEHost = cfg.domain;
          acmeRoot = null;
        };
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
