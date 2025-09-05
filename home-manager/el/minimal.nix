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

    sheldon = {
      enable = true;
      enableZshIntegration = true;
      # plugins = {
      #   elanora96-zsh-plugins = {
      #     github = "elanora96/zsh-plugins";
      #   };
      #   zsh-syntax-highlighting = {
      #     github = "zsh-users/zsh-syntax-highlighting";
      #     apply = [ "defer" ];
      #   };
      #   zsh-autosuggestions = {
      #     github = "zsh-users/zsh-autosuggestions";
      #     apply = [ "defer" ];
      #   };
      # };
      # templates = {
      #   defer = ''
      #     {{ hooks | get: "pre" | nl }}{% for file in files %}zsh-defer source "{{ file }}"
      #     {% endfor %}{{ hooks | get: "post" | nl }}'';
      # };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
      };
    };

    tealdeer.enable = true;

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "gruvbox-dark";
      };
    };

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
