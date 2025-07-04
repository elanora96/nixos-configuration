{ pkgs, ... }:

{
  imports = [ ../. ];

  home = {
    username = "el";
    homeDirectory = "/home/el";

    packages = with pkgs; [
      chezmoi
      jellyfin-ffmpeg
      nil
      nixfmt-rfc-style
      qrcp
    ];
  };

  programs = {
    bottom.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    gh.enable = true;

    git = {
      delta.enable = true;
      enable = true;
      userName = "Elanora Manson";
      userEmail = "git@elanora.lol";
    };

    jq.enable = true;
    lazygit.enable = true;
    lsd.enable = true;

    neovim = {
      defaultEditor = true;
      enable = true;
      withNodeJs = true;
      withPython3 = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };

    pandoc.enable = true;

    ssh = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };

    tealdeer.enable = true;

    zsh = {
      autosuggestion.enable = true;
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      syntaxHighlighting.enable = true;
    };
  };
}
