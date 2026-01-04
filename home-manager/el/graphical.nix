{ pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home = {
    packages = with pkgs; [
      meslo-lgs-nf
      signal-desktop-bin
      thunderbird
      vscodium
      zed-editor
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
