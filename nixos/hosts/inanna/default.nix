{
  inputs,
  pkgs,
  config,
  ...
}:

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
    ../../hardware/gpu-nvidia-gtx-1070
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];

  fonts.fontDir.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.el = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "media"
        config.services.syncthing.group
      ];
    };
  };

  homelab = {
    enable = true;
    domain = "internal.elanora.lol";
    storage = "/mnt/media";
  };

  region = "us-westcoast";

  system.stateVersion = "24.05"; # Don't touch!
}
