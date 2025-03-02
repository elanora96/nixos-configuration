{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab;
in
{
  imports = [ ./traefik.nix ];

  options.homelab = {
    enable = lib.mkEnableOption "homelab";
    domain = lib.mkOption {
      type = lib.types.str;
    };
    storage = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/media";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: For Sonarr v4, provide if v4?
    nixpkgs.config.permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.36"
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.428"
    ];

    homelab.traefik = {
      enable = true;
      services = {
        plex.port = 32400;
        jellyfin.port = 8096;
        sonarr.port = 8989;
        radarr.port = 7878;
        prowlarr.port = 9696;
      };
    };

    services = {
      plex = {
        enable = true;
        openFirewall = true;
        user = "el";
      };

      jellyfin = {
        enable = true;
        user = "el";
      };

      radarr = {
        enable = true;
        openFirewall = true;
        user = "el";
      };

      sonarr = {
        enable = true;
        openFirewall = true;
        user = "el";
        # TODO: For Sonarr v4, provide if v4?
        package = pkgs.sonarr.overrideAttrs (lib.const { doCheck = false; });
      };

      prowlarr = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
