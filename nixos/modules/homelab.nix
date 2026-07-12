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
    sops.secrets =
      let
        rootOwnedNginxGroupRead = {
          inherit (config.services.nginx) group;
          mode = "0440";
        };
      in
      {
        # keep-sorted start block=yes
        "porkbun/api_key" = rootOwnedNginxGroupRead;
        "porkbun/secret_api_key" = rootOwnedNginxGroupRead;
        # keep-sorted end
      };

    environment.systemPackages = with pkgs; [
      qbittorrent-nox
    ];

    networking.firewall.allowedTCPPorts =
      let
        qbittorrentPort = 7470;
      in
      [
        80
        443
        qbittorrentPort
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
          locations."/" =
            let
              index = "index.html";
            in
            {
              inherit index;
              root = pkgs.writeTextDir index ''
                <!DOCTYPE html lang="en">
                <html>
                <head>
                  <meta charSet="UTF-8"/>
                  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                  <title>${cfg.domain}</title>
                </head>
                <body>
                  <h1>You have reached</h1>
                  <p>nothing really</p>
                </body>
                </html>
              '';
            };
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
