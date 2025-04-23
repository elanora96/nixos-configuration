{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix

    # Hardware modules
    ../../hardware/cpu-amd-r7-3700x
    ../../hardware/gpu-nvidia-gtx-1070 # Includes driver cfg
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  nix.settings.download-buffer-size = 524288000;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  networking = {
    hostName = "inanna";
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [
      8000
      3030
    ];
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      # extraConfig.pipewire."92-low-latency" = {
      #   "context.properties" = {
      #     "default.clock.rate" = 48000;
      #   };
      # };
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.el = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
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

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };

  homelab = {
    enable = true;
    domain = "inanna.internal";
    storage = "/mnt/media";
    traefik = {
      enable = true;
      docker.enable = true;
      services.cache = {
        port = 5000;
      };
    };
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.05"; # Don't touch!
}
