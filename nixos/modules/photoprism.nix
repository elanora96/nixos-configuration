{ config, lib, ... }:
let
  inherit (config) homelab;
  cfg = config.services.photoprism;
  domain = "photoprism.${homelab.domain}";
in
{
  config = lib.mkIf homelab.enable {
    sops.secrets =
      let
        rootOwnedGroupRead = {
          inherit (cfg) group;
          mode = "0440";
        };
      in
      {
        "photoprism/admin_password" = rootOwnedGroupRead;
        "photoprism/db_password" = rootOwnedGroupRead;
      };

    services.photoprism = {
      enable = true;
      passwordFile = config.sops.secrets."photoprism/admin_password".path;
      databasePasswordFile = config.sops.secrets."photoprism/db_password".path;
    };

    services.nginx.virtualHosts.${domain} = {
      forceSSL = true;
      useACMEHOST = homelab.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          proxy_buffering off;
          proxy_http_version 1.1;
        '';
      };
    };
  };
}
