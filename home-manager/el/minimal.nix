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
      settings = {
        theme = "gruvbox-dark";
      };
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
