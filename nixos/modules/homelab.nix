{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab;
  # TODO: This shouldn't be a thing really
  unproxiedServiceNamePort = {
    # keep-sorted start block=yes
    home-assistant = config.services.home-assistant.config.http.server_port;
    lidarr = config.services.lidarr.settings.server.port;
    ollama = config.services.ollama.port;
    open-webui = config.services.open-webui.port;
    prowlarr = config.services.prowlarr.settings.server.port;
    qbittorrent-web = 7470;
    radarr = config.services.radarr.settings.server.port;
    sonarr = config.services.sonarr.settings.server.port;
    syncthing = lib.removePrefix "127.0.0.1:" config.services.syncthing.guiAddress;
    # keep-sorted end
  };
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

    networking.firewall.allowedTCPPorts = [
      80
      443
      unproxiedServiceNamePort.qbittorrent-web
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
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
        virtualHosts.${cfg.domain} = {
          forceSSL = true;
          useACMEHost = cfg.domain;
          acmeRoot = null;
          locations."/" =
            let
              index = "index.html";
              virtualHosts = builtins.filter (virtualHost: virtualHost != "_") (
                builtins.attrNames config.services.nginx.virtualHosts
              );
              proxiedLinks = map (service: "<a href=\"https://${service}\">${service}</a>") virtualHosts;
              unproxiedLinks = lib.mapAttrsToList (
                name: port:
                let
                  url = "http://inanna.internal:${toString port}";
                in
                "<a href=\"${url}\">${name} (${url})</a>"
              ) unproxiedServiceNamePort;
              toListItems = x: "<li>${builtins.concatStringsSep "</li><li>" x}</li>";
            in
            {
              inherit index;
              root = pkgs.writeTextDir index ''
                <!DOCTYPE html>
                <html lang="en">
                <head>
                  <meta charset="UTF-8"/>
                  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                  <style>
                    :root {
                      --highlight-border-radius:7px;
                      --border-radius:11px;
                      --yellow-highlight:#fffab7;
                      --links:#0f6dff;
                      --background-body:#fff;
                      --background-main:#f1f1f1;
                      --background-inputs:#fcfcfc;
                      --text:#1c1d1e;
                      --border:#ddd;
                      --focus-highlight:#b8b8b8;
                      --shadow-color:#545454;
                    }
                    @media (prefers-color-scheme:dark) {
                      :root {
                        --links:#4589ee;
                        --background-body:#0f0f0f;
                        --background-main:#222;
                        --background-inputs:#222;
                        --text:#efefef;
                        --border:#444;
                        --focus-highlight:#888;
                        --shadow-color:#bebebe;
                      }
                    }
                    *,
                    :after,
                    :before {
                      box-sizing:border-box
                    }
                    html,
                    body {
                      color:var(--text);
                      background:var(--background-body);
                      margin:0;
                      font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen-Sans,Ubuntu,Cantarell,Helvetica Neue,sans-serif;
                      font-size:12pt
                    }
                    h1 {
                      font-size:2.5rem
                    }
                    h2 {
                      font-size:2rem
                    }
                    h3 {
                      font-size:1.75rem
                    }
                    h4 {
                      font-size:1.5rem
                    }
                    h5 {
                      font-size:1.25rem;
                      font-weight:400
                    }
                    h6 {
                      font-size:1rem;
                      font-weight:400
                    }
                    h1,
                    h2,
                    h3,
                    h4,
                    h5,
                    h6 {
                      margin-top:.5rem;
                      margin-bottom:.5rem
                    }
                    h1,
                    h2,
                    h3,
                    h4,
                    b,
                    strong,
                    th {
                      font-weight:700
                    }
                    li,
                    p {
                      line-height:1.6em
                    }
                    a {
                      color:var(--links)
                    }
                    a:active,
                    a:hover,
                    a:focus {
                      text-decoration:none
                    }
                  </style>
                  <title>${cfg.domain}</title>
                </head>
                <body>
                  <h1>${cfg.domain}</h1>
                  <h3>Nginx virtualhosts</h3>
                  <ul>
                    ${toListItems proxiedLinks}
                  </ul>
                  <h3>Unproxied Links</h3>
                  <p><i>Not all of these are available outside the host</i></p>
                  <ul>
                    ${toListItems unproxiedLinks}
                  </ul>
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
