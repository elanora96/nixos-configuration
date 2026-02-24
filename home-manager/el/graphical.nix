{ pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home = {
    packages = with pkgs; [
      # keep-sorted start
      hunspell
      hunspellDicts.en_US
      kdePackages.filelight
      kdePackages.partitionmanager
      libreoffice-qt6-fresh
      meslo-lgs-nf
      signal-desktop-bin
      tauon
      thunderbird
      vscodium
      zed-editor
      # keep-sorted end
    ];

  };

  programs = {
    # keep-sorted start block=yes

    alacritty = {
      enable = true;
      theme = "gruvbox_material";
    };
    firefox = {
      enable = true;
    };
    mpv = {
      enable = true;
      config = {
        sub-auto = "fuzzy";
      };
    };
    # keep-sorted end
  };
}
