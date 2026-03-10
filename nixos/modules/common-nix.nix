{ lib, ... }:
{
  nix.settings = {
    max-jobs = lib.mkDefault "auto";
    experimental-features = lib.mkDefault [
      "nix-command"
      "flakes"
    ];
  };
}
