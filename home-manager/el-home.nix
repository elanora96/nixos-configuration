{ pkgs, ... }:

{
  home = {
    username = "el";
    homeDirectory = "/home/el";
    packages = with pkgs; [
      chezmoi
      jellyfin-ffmpeg
      meslo-lgs-nf
      nil
      nixfmt-rfc-style
      qbittorrent
      qrcp
      signal-desktop-bin
      steam-unwrapped
      thunderbird
      vscodium
      zoom-us
      zsh-powerlevel10k
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager. If you don't want to manage your shell
    # through Home Manager then you have to manually source 'hm-session-vars.sh'
    # located at either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/el/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      # EDITOR = "nvim";
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.
  };

  programs = {
    alacritty.enable = true;
    bottom.enable = true;
    fastfetch.enable = true;
    fd.enable = true;

    firefox = {
      enable = true;
    };

    gh.enable = true;

    git = {
      enable = true;
      userName = "Elanora Manson";
      userEmail = "git@elanora.lol";
      delta = {
        enable = true;
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    jq.enable = true;

    keychain = {
      enable = true;
      enableZshIntegration = true;
      agents = [ "ssh" ];
      keys = [
        "id_ed25519_el_inanna_2024-10-14"
        "id_ed25519_el_inanna_gh_2024-10-14"
      ];
    };

    lazygit.enable = true;
    lsd.enable = true;
    mpv.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
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

    obs-studio.enable = true;
    pandoc.enable = true;
    poetry.enable = true;

    ssh = {
      enable = true;
    };

    tealdeer.enable = true;

    yt-dlp.enable = true;

    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
    };
  };

}
