{ pkgs, ... }:

{
  imports = [
    ../.
  ];

  home = {
    username = "el";

    packages = with pkgs; [
      # keep-sorted start
      chezmoi
      dust
      jellyfin-ffmpeg
      nil
      nix-tree
      nixd
      nixfmt
      qrcp
      # keep-sorted end
    ];
  };

  programs = {
    # keep-sorted start block=yes
    bottom.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    direnv-instant.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    gh.enable = true;
    git = {
      enable = true;
      settings.user.name = "Elanora Manson";
      settings.user.email = "git@elanora.lol";
      signing.format = "openpgp";
    };
    jq.enable = true;
    lazygit.enable = true;
    lsd.enable = true;
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };
    nixvim = {
      enable = true;
      imports = [ ../programs/nixvim ];
    };
    pandoc.enable = true;
    sheldon = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        shell = "zsh";
        plugins = {
          elanora96-zsh-plugins = {
            github = "elanora96/zsh-plugins";
          };
        };
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
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
      exitShellOnExit = true;
      settings = {
        /**
          .kdl allows for some Nix Attr breaking patterns
          Nix -> KDL functions live in home-manager/modules/lib/generators.nix
          Several keys to note:
          - _props - Allows for prop attributes
          - _args - Allows for string arguments
          - _children - Allows for list of attributes
        */
        plugins = {
          autolock = {
            _props.location = "https://github.com/fresh2dev/zellij-autolock/releases/latest/download/zellij-autolock.wasm";
            is_enabled = true;
            # Lock when any open these programs open. They are expected to unlock themselves when closed (e.g., using zellij-nav.nvim plugin).
            triggers = "nvim|vim|git|lazygit|fzf|yazi|zoxide";
            # Reaction to input occurs after this many seconds. (default=0.3)
            # (An existing scheduled reaction prevents additional reactions.)
            reaction_seconds = "0.3";
            # Print to Zellij log? (default=false)
            print_to_log = true;
          };
        };
        # Load "headless" plugins on start.
        load_plugins = {
          autolock = { };
        };
        show_startup_tips = false;
        theme = "gruvbox-dark";
      };
    };
    zk = {
      enable = true;
    };
    zsh = {
      autosuggestion.enable = true;
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
    # keep-sorted end
  };
}
