{ pkgs, ... }:
{
  imports = [ ../../modules/minimal-packages.nix ];

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    kdePackages.audiocd-kio
    kdePackages.isoimagewriter
    ntfs2btrfs
    picard
    python3
    unar
    uv
    watchman
    waypipe
    wireguard-tools
    wl-clipboard
    yazi
    # keep-sorted end
  ];
}
