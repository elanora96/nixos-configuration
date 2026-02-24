{ pkgs, ... }:
{
  imports = [ ../../modules/minimal-packages.nix ];

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    ntfs2btrfs
    uv
    watchman
    waypipe
    wireguard-tools
    # keep-sorted end
  ];
}
