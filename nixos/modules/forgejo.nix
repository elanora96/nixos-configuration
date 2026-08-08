{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config) homelab;
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
  DOMAIN = "git.${homelab.domain}";
in
{
  sops.secrets = {
    "forgejo/admin_password" = {
      mode = "400";
      owner = "forgejo";
    };
    # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
    "forgejo/runner-token" = {
      mode = "400";
      owner = "forgejo";
    };
  };

  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets."forgejo/admin_password";
      user = "henry"; # Forgejo doesn't allow creation of "admin"
    in
    ''
      ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        inherit DOMAIN;
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${srv.DOMAIN}/";
        HTTP_PORT = 3287;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "jude";
      url = DOMAIN;
      tokenFile = config.sops.secrets."forgejo/runner-token".path;
      labels = [
        # "ubuntu-latest:docker://node:16-bullseye"
        # "ubuntu-22.04:docker://node:16-bullseye"
        # "ubuntu-20.04:docker://node:16-bullseye"
        # "ubuntu-18.04:docker://node:16-buster"
        ## optionally provide native execution on the host:
        "native:host"
      ];
    };
  };

  services.nginx.virtualHosts.${cfg.settings.server.DOMAIN} = {
    forceSSL = true;
    useACMEHost = homelab.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString srv.HTTP_PORT}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
    };
  };
}
