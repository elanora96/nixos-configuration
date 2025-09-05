{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [ inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime ];

  # Misleading name, this is required for Wayland as well
  services.xserver.enable = true;
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # Required for Firefox hardware decode
        # Be sure to configure correctly
        nvidia-vaapi-driver
      ];
    };

    nvidia = {
      modesetting.enable = true;
      # Unavailable for pascal desktop
      powerManagement.finegrained = false;
      # Unavailable for pascal desktop
      open = false;
      # nvidiaPersistenced = true;
      nvidiaSettings = true;
      # As of 2025 beta releases are stable enough with large Wayland improvements
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  environment.sessionVariables = {
    # VAAPI variables
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
