{
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

    # Hardware modules
    ../../hardware/mb-gigabyte-x570-aorus-elite.nix
    ../../hardware/gpu-nvidia-gtx-1070
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

  bluetooth = {
    enable = true;
    gaming = true;
  };

  homelab = {
    enable = true;
    domain = "internal.elanora.lol";
    storage = "/mnt/media";
  };

  region = "us-westcoast";

  system.stateVersion = "24.05"; # Don't touch!
}
