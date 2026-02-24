# Packages I want on every system
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    bottom
    dust
    fd
    lsd
    nixfmt
    ripgrep
    wget
    zellij
    # keep-sorted end
  ];
}
