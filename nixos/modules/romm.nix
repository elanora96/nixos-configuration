{ config, ... }:
let
  inherit (config) homelab;
  ROMM_DOMAIN = "romm.${homelab.domain}";
in
{
  sops.secrets."ROMM_ENVIRONMENT_FILE" = { };

  services.romm = {
    enable = true;
    nginx = {
      enable = true;
      virtualHost = ROMM_DOMAIN;
    };
    environmentFile = config.sops.secrets."ROMM_ENVIRONMENT_FILE".path;
    port = 8634;
    watcher.enable = true;
  };

  services.nginx.virtualHosts.${ROMM_DOMAIN} = {
    forceSSL = true;
    useACMEHost = homelab.domain;
  };
}
