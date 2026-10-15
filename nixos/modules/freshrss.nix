{ config, pkgs, ... }:
let
  inherit (config) homelab;
  cfg = config.services.freshrss;
  DOMAIN = "freshrss.${homelab.domain}";
in
{
  sops.secrets = {
    "freshrss/password" = {
      mode = "400";
      owner = cfg.user;
    };
  };

  services.freshrss = {
    enable = true;
    virtualHost = DOMAIN;
    baseUrl = "https://${DOMAIN}";
    webserver = "nginx";
    defaultUser = "el";
    passwordFile = config.sops.secrets."freshrss/password".path;
    api.enable = true;
    extensions = with pkgs.freshrss-extensions; [
      reading-time
      youtube
    ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "freshrss" ];
    ensureUsers = [
      {
        name = "freshrss";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts.${DOMAIN} = {
    forceSSL = true;
    useACMEHost = homelab.domain;
  };
}
