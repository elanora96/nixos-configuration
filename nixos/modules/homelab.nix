{
  config,
  lib,
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
    # homelab.traefik = {
    #   enable = true;
    #   services = {
    #     plex.port = 32400;
    #     jellyfin.port = 8096;
    #     sonarr.port = 8989;
    #     radarr.port = 7878;
    #     prowlarr.port = 9696;
    #   };
    # };

    services = {
      plex = {
        enable = true;
        openFirewall = true;
        user = "el";
      };

      jellyfin = {
        enable = true;
        openFirewall = true;
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

      traefik = {
        enable = true;
        staticConfigOptions = {
          entryPoints = {
            web = {
              address = ":80";
              asDefault = true;
              http.redirections.entrypoint = {
                to = "websecure";
                scheme = "https";
              };
            };
            websecure = {
              address = ":443";
              asDefault = true;
              http.tls.certResolver = "letsencrypt";
            };
            log = {
              level = "INFO";
              filePath = "${config.services.traefik.dataDir}/traefik.log";
              format = "json";
            };

            certificatesResolvers.letsencrypt.acme = {
              email = "postmaster@inanna.internal";
              storage = "${config.services.traefik.dataDir}/acme.json";
              httpChallenge.entryPoint = "web";
            };

            api.dashboard = true;
            # Access the Traefik dashboard on <Traefik IP>:8080 of your server
            # api.insecure = true;
          };
        };

        dynamicConfigOptions = {
          routers = {
            plex = {
              entryPoints = [ "websecure" ];
              rule = "Host(`plex.${cfg.domain}`)";
              service = "plex";
            };
            jellyfin = {
              entryPoints = [ "websecure" ];
              rule = "Host(`jellyfin.${cfg.domain}`)";
              service = "jellyfin";
            };
            sonarr = {
              entryPoints = [ "websecure" ];
              rule = "Host(`sonarr.${cfg.domain}`)";
              service = "sonarr";
            };
            radarr = {
              entryPoints = [ "websecure" ];
              rule = "Host(`radarr.${cfg.domain}`)";
              service = "radarr";
            };
            prowlarr = {
              entryPoints = [ "websecure" ];
              rule = "Host(`prowlarr.${cfg.domain}`)";
              service = "prowlarr";
            };
          };
          services = {
            plex = {
              loadBalancer = {
                servers = [
                  { url = "http://plex:32400"; }
                ];
              };
            };
            jellyfin = {
              loadBalancer = {
                servers = [
                  { url = "http://jellyfin:8096"; }
                ];
              };
            };
            sonarr = {
              loadBalancer = {
                servers = [
                  { url = "http://sonarr:8989"; }
                ];
              };
            };
            radarr = {
              loadBalancer = {
                servers = [
                  { url = "http://radarr:7878"; }
                ];
              };
            };
            prowlarr = {
              loadBalancer = {
                servers = [
                  { url = "http://prowlarr:9696"; }
                ];
              };
            };
          };
        };
      };
    };
  };
}
