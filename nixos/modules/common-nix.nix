{ lib, config, ... }:
{
  options.nix.settings = {
    max-jobs = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    experimental-features = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = [ ];
    };
    commit-lockfile-summary = {
      type = lib.types.str;
      default = "";
    };
  };

  config = {
    nix.settings = {
      max-jobs = "auto";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      commit-lockfile-summary = "Lock update";
    };

    flake.modules = {
      nixos.base.nix = {
        inherit (config.nix) settings;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
        optimise.automatic = true;
      };

      homeManager.base.nix = {
        inherit (config.nix) settings;
      };
    };
  };
}
