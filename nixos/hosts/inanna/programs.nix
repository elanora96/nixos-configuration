_: {
  programs = {
    # keep-sorted start block=yes
    appimage = {
      enable = true;
      binfmt = true;
    };
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
    };
    idescriptor = {
      enable = true;
      users = [ "el" ];
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
    nix-ld.enable = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
    # keep-sorted end
  };

  # Required for iDescriptor
  services.avahi = {
    enable = true;
    openFirewall = true;
    reflector = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
