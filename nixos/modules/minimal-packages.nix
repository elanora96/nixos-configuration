{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bottom
    fd
    lsd
    nixfmt-rfc-style
    ripgrep
    wget
    zellij
  ];
}
