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

  modules = {
    inherit (config.flake.modules.nixos) base gaming;
  };

  # This was necessary at one point? Is it still?
  # nix.settings.download-buffer-size = 524288000;

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
