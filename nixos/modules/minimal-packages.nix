# Packages I want on every system
let
  getBasePackages =
    pkgs: with pkgs; [
      # keep-sorted start
      age
      bottom
      dust
      fd
      fzf
      just
      lsd
      nixd
      nixfmt
      ripgrep
      sops
      wget
      zellij
      # keep-sorted end
    ];
in
{
  flake.modules.nixos.base = { pkgs, ... }: {
    environment.systemPackages = getBasePackages pkgs;
  };
  flake.modules.homeManager.base = { pkgs, ... }: {
    home.packages = getBasePackages pkgs;
  };
}
