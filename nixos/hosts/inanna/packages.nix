{ pkgs, ... }:
{
  imports = [ ../../modules/minimal-packages.nix ];

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    ntfs2btrfs
    picard
    uv
    watchman
    waypipe
    wireguard-tools
    yazi
    # keep-sorted end
  ];
}
