{ config, lib, ... }:
let
  inherit (config) homelab;
  cfg = config.services.paperless;
  domain = "paperless.${homelab.domain}";
in
{
  config = lib.mkIf homelab.enable {
    sops.secrets = {
      "paperless/admin_password" = {
        owner = cfg.user;
        mode = "0440";
      };
    };

    services.paperless = {
      inherit domain;
      enable = true;
      consumptionDirIsPublic = true;
      passwordFile = config.sops.secrets."paperless/admin_password".path;
      settings = {
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
          "Thumbs.db"
        ];
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_FILENAME_FORMAT = "{created_year}/{correspondent}/{title}";
        PAPERLESS_FILENAME_FORMAT_REMOVE_NONE = true;
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
        # Used so that I can put files for a user into /consume/userA
        PAPERLESS_CONSUMER_RECURSIVE = true;
      };
    };

    services.nginx = {
      virtualHosts.${domain} = {
        forceSSL = true;
        useACMEHost = homelab.domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 200M;
            proxy_read_timeout 300s;
            proxy_connect_timeout 300s;
            proxy_send_timeout 300s;
          '';
        };
      };
    };
  };
}
