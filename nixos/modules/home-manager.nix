{
  self,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [
        self.home-modules.common
      ];
    }
  ];
  home-modules = {
    common =
      { config, pkgs, ... }:
      {
        # Sensible default for `home.homeDirectory`
        home.homeDirectory = lib.mkDefault "/${
          if pkgs.stdenv.isDarwin then "Users" else "home"
        }/${config.home.username}";

        # For macOS, $PATH must contain these.
        home.sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
          "/etc/profiles/per-user/$USER/bin" # To access home-manager binaries
          "/nix/var/nix/profiles/system/sw/bin" # To access nix-darwin binaries
          "/usr/local/bin" # Some macOS GUI programs install here
        ];
      };
  };
}
