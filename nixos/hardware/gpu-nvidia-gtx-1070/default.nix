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
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      # 580.xx finishes support for Pascal
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  environment.sessionVariables = {
    # VAAPI variables
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
