# Packages I want on every system
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
}
