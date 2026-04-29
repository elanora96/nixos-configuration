{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.direnv-instant.homeModules.direnv-instant
    inputs.nixvim.homeModules.nixvim
  ];

  home = {
    # Sensible default for `home.homeDirectory`
    homeDirectory = lib.mkDefault "/${
      if pkgs.stdenv.isDarwin then "Users" else "home"
    }/${config.home.username}";

    # For macOS, $PATH must contain these.
    sessionPath = lib.mkIf pkgs.stdenv.isDarwin [
      "/etc/profiles/per-user/$USER/bin" # To access home-manager binaries
      "/nix/var/nix/profiles/system/sw/bin" # To access nix-darwin binaries
      "/usr/local/bin" # Some macOS GUI programs install here
    ];

    # Leave it alone!
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
