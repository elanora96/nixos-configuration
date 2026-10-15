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
    extensions =
      let
        inherit (pkgs.freshrss-extensions) reading-time buildFreshRssExtension;
        latextSupport = buildFreshRssExtension {
          FreshRssExtUniqueId = "LatexSupport";
          pname = "xExtension-LatexSupport";
          version = "0.1.5";
          src = pkgs.fetchFromGitHub {
            owner = "aledeg";
            repo = "xExtension-LatexSupport";
            rev = "d98fc56a7a12f04a913beea9a8ee81e463ad1b92";
            sha256 = "pk4E7xl5DqujJxHiMuNO9m144As+F+9lii47nYWZbLc=";
          };
        };
      in
      [
        reading-time
        latextSupport
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
