{
  config,
  lib,
  services,
  ...
}:

let
  hl = config.homelab;
  cfg = hl.traefik;

  serviceOptions =
    _: with lib; {
      options = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
        };
        port = mkOption {
          type = types.port;
        };
        ipWhitelist = mkOption {
          type = types.str;
          default = "";
        };
        middlewares = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };

  metricsOptions =
    _: with lib; {
      options = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
        };
        port = mkOption {
          type = types.port;
          default = 0;
        };
        service = mkOption {
          type = types.str;
          default = "";
        };
      };
    };

  mkService = name: value: {
    loadBalancer = {
      servers = [
        { url = "http://${value.host}:${builtins.toString value.port}"; }
      ];
    };
  };

  mkRouter =
    name: value:
    let
      ipWhitelist = if (value.ipWhitelist != "") then value.ipWhitelist else cfg.defaultIPWhitelist;
    in
    {
      rule = "Host(`${name}.${hl.domain}`)";
      service = name;
      entrypoints = [ cfg.entrypoint ];
      middlewares = value.middlewares ++ lib.lists.optional (ipWhitelist != "") ipWhitelist;
    };

  mkMetricsRouter =
    name: value:
    lib.nameValuePair "${name}-metrics" {
      rule = "Host(`${name}.${hl.domain}`) && Path(`/metrics`)";
      service = if (value.service != "") then value.service else name;
      entrypoints = [ cfg.entrypoint ];
      middlewares = [ "localhost-only" ];
    };
in
{
  options.homelab.traefik = with lib; {
    enable = mkEnableOption "traefik";
    docker.enable = mkEnableOption "docker" // {
      default = config.virtualisation.docker.enable;
    };
    services = mkOption {
      type = types.attrsOf (types.submodule serviceOptions);
      default = { };
    };
    metrics = mkOption {
      type = types.attrsOf (types.submodule metricsOptions);
      default = { };
    };
    cloudflareTLS = {
      enable = mkEnableOption "cloudflareTLS";
      apiEmailFile = mkOption {
        type = types.str;
      };
      dnsApiTokenFile = mkOption {
        type = types.str;
      };
    };
    entrypoint = mkOption {
      default = "web";
      readOnly = true;
    };
    defaultIPWhitelist = mkOption {
      type = types.str;
      default = "local-ip-whitelist";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.traefik = {
          enable = true;
          group = lib.mkIf cfg.docker.enable "docker";
          staticConfigOptions = lib.mkMerge [
            {
              log.level = "info";
              providers = lib.mkIf cfg.docker.enable { docker = { }; };
              entryPoints.web.address = ":80";
              api.dashboard = true;
              global = {
                checknewversion = false;
                sendanonymoususage = false;
              };
            }
          ];
          dynamicConfigOptions = {
            http = {
              routers = lib.mkMerge [
                (builtins.mapAttrs mkRouter cfg.services)
                {
                  traefik = {
                    rule = "Host(`traefik.${hl.domain}`)";
                    service = "api@internal";
                    middlewares = lib.lists.optional (cfg.defaultIPWhitelist != "") cfg.defaultIPWhitelist;
                    entrypoints = [ cfg.entrypoint ];
                  };
                }
              ];
              services = builtins.mapAttrs mkService cfg.services;
              middlewares = {
                localhost-only.IPWhitelist.sourceRange = [ "127.0.0.1/32" ];
                local-ip-whitelist.IPWhiteList = {
                  sourceRange = [
                    "127.0.0.1/32"
                    "10.0.0.0/8"
                    "172.16.0.0/12"
                    "192.168.0.0/16"
                  ];
                };
              };
            };
          };
        };
      }
    ]
  );
}
