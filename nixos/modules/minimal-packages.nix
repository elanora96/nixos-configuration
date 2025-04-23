{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bottom
    fd
    lsd
    nil
    ripgrep
    wget
  ];
}
