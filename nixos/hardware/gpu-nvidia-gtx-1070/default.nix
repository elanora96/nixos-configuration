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
      # New patchelf breaks nvidia-smi...
      # https://github.com/NixOS/nixpkgs/pull/576397
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580.overrideAttrs (old: {
        builder = pkgs.runCommand "nvidia-x11-builder.sh" { } ''
          cp ${old.builder} $out
          chmod u+w $out
          patch $out ${
            pkgs.fetchpatch {
              url = "https://github.com/NixOS/nixpkgs/commit/ae9ba0c0ab398dd76b2e34721c9c19fbed16e0b1.patch";
              relative = "pkgs/os-specific/linux/nvidia-x11";
              hash = "sha256-i7B44In5P74RU4GKVWmVO4VnughlbT+4PDpqzry3hcc=";
            }
          }
        '';
      });
    };
  };

  environment.sessionVariables = {
    # VAAPI variables
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
  };
}
