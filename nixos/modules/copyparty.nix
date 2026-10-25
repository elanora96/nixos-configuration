{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config) homelab;
  cfg = config.services.copyparty;
  COPYPARTY_DOMAIN = "copyparty.${homelab.domain}";
  package = pkgs.copyparty-full;
in
{
  imports = [ inputs.copyparty.nixosModules.default ];

  sops.secrets = {
    "copyparty/el_password" = {
      mode = "400";
      owner = "copyparty";
    };
  };

  services.copyparty = {
    inherit package;
    enable = true;
    user = "copyparty";
    group = "media";
    accounts = {
      el.passwordFile = config.sops.secrets."copyparty/el_password".path;
    };
    # directly maps to values in the [global] section of the copyparty config.
    # see `copyparty --help` for available options
    settings = {
      i = "127.0.0.1";
      p = 3210;
      # use booleans to set binary flags
      no-reload = true;
      # using 'false' will do nothing and omit the value when generating a config
      ignored-flag = false;
    };
    groups = {
      admin = [ "el" ];
    };

    volumes = {
      # create a volume at "/" (the webroot), which will
      "/" = {
        # share the contents of "/srv/copyparty"
        path = "/";
        # see `copyparty --help-accounts` for available options
        access.rw = "@admin";
        # see `copyparty --help-flags` for available options
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 60;
          # volflag "e2d" enables the uploads database
          e2d = true;
        };
      };
      "/public" = {
        # share the contents of "/srv/copyparty"
        path = "/mnt/media/srv/copyparty";
        # see `copyparty --help-accounts` for available options
        access.rw = "*";
        # see `copyparty --help-flags` for available options
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 60;
          # volflag "e2d" enables the uploads database
          e2d = true;
        };
      };
    };
  };

  services.nginx.virtualHosts."${COPYPARTY_DOMAIN}" = {
    forceSSL = true;
    useACMEHost = homelab.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.settings.p}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
          # No upload limit
          client_max_body_size 0;
          # Disable buffering
        	proxy_buffering off;
        	proxy_request_buffering off;
        	# Improve download speed
        	proxy_buffers 32 8k;
        	proxy_buffer_size 16k;
        	proxy_busy_buffers_size 24k;
      '';
    };
  };
}
