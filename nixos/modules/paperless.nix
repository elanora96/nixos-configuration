{ config, lib, ... }:
let
  inherit (config) homelab;
  cfg = config.services.paperless;
in
{
  config = lib.mkIf homelab.enable {
    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
    };

    services.paperless = {
      enable = true;
      consumptionDirIsPublic = true;

      address = "0.0.0.0";
      # domain = "https://paperless.${homelab.domain}";

      settings = {
        # Needed for CSRF etc
        # PAPERLESS_URL = cfg.domain;
        # PAPERLESS_CSRF_TRUSTED_ORIGIN = cfg.domain;
        # PAPERLESS_CORS_ALLOWED_HOSTS = "http://localhost:${lib.toString cfg.port},${cfg.domain}";
        # Ignore some junk
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
        ];
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_FILENAME_FORMAT = "{{ owner_username }}/{{ correspondent }}/{{ created }} {{ title }}";
        PAPERLESS_FILENAME_FORMAT_REMOVE_NONE = true;
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
        # Used so that I can put files for a user into /consume/userA
        PAPERLESS_CONSUMER_RECURSIVE = true;
      };
    };
  };
}
