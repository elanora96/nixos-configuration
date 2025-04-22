# configuration.nix(5)
# https://search.nixos.org/options
# nixos-help

{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./homelab.nix
    ./traefik.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    download-buffer-size = 524288000;
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "inanna";
    networkmanager.enable = true;

    firewall.allowedTCPPorts = [
      8000
      3030
    ];
  };

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    desktopManager.plasma6.enable = true;

    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    openssh.enable = true;

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

    printing.enable = true;

    tailscale.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;

    users.el = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      bottom
      fd
      lsd
      nil
      ntfs2btrfs
      ripgrep
      uv
      watchman
      waypipe
      wget
    ];
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
