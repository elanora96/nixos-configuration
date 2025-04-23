{ ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services = {
    desktopManager.plasma6.enable = true;

    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
