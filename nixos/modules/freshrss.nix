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
        freshrss-flaresolverr = buildFreshRssExtension {
          FreshRssExtUniqueId = "freshrss-flaresolverr";
          pname = "xExtension-FlareSolverr";
          version = "0.4.3";
          src = pkgs.fetchFromGitHub {
            owner = "ravenscroftj";
            repo = "freshrss-flaresolverr-extension";
            rev = "f01c02dff8cf26dc6e5a52fe3443aa321a3a620a";
            sha256 = "GiC8mYBN/Y22/tB++HLMHUKJViMV9h2hNrI5upXodNM=";
          };
        };
        AppleMusicArtist = buildFreshRssExtension {
          FreshRssExtUniqueId = "AppleMusicArtist";
          pname = "xExtension-AppleMusicArtist";
          version = "0.0.1";
          src = pkgs.fetchFromCodeberg {
            owner = "sanpo";
            repo = "xExtension-AppleMusicArtist";
            rev = "9389b29800274bce22a02a55250f9c3d74213755";
            sha256 = "4r+t9lwQXakbCkTZsVDCmgDcwxS4yYE1TH1HhKC6V9E=";
          };
        };
      in
      [
        reading-time
        latextSupport
        freshrss-flaresolverr
        AppleMusicArtist
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
