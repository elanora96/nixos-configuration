{ config, pkgs, ... }:

let
  hl = config.homelab;
in
{
  nixpkgs.config = {
    # For Sonarr v4
    permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.36"
      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.428"
    ];
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
      package = pkgs.sonarr.overrideAttrs (lib.const { doCheck = false; });
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
