{ pkgs, ... }:
{
  imports = [ ../../modules/minimal-packages.nix ];

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    kdePackages.audiocd-kio
    ntfs2btrfs
    picard
    python3
    uv
    watchman
    waypipe
    wireguard-tools
    yazi
    # keep-sorted end
  ];
}
