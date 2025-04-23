{ pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home = {
    packages = with pkgs; [
      meslo-lgs-nf
      qbittorrent
      signal-desktop-bin
      steam-unwrapped
      thunderbird
      vscodium
      zoom-us
      zsh-powerlevel10k
    ];

  };

  programs = {
    alacritty.enable = true;

    firefox = {
      enable = true;
    };

    mpv.enable = true;
  };
}
