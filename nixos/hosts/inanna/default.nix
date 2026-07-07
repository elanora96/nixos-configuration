{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./programs.nix
    ./networking.nix
    ./audio.nix
    ./bluetooth.nix

    # Hardware modules
    ../../hardware/cpu-amd-r7-3700x
    ../../hardware/gpu-nvidia-gtx-1070 # Includes driver cfg
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    settings.download-buffer-size = 524288000;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  users = {
    defaultUserShell = pkgs.zsh;

    users.el = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "media"
      ];
    };
  };

  homelab = {
    enable = true;
    domain = "internal.elanora.lol";
    storage = "/mnt/media";
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.05"; # Don't touch!
}
