{ pkgs, ... }:
{
  imports = [ ../../modules/minimal-packages.nix ];

  environment.systemPackages = with pkgs; [
    ntfs2btrfs
    uv
    watchman
    waypipe
  ];
}
