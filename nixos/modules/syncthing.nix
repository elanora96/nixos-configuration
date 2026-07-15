{ config, ... }: {
  sops.secrets."syncthing/gui_password" = {
    inherit (config.services.syncthing) group;
    mode = "0440";
  };

  services.syncthing = {
    enable = true;
    settings = {
      gui.user = "el";
      guiPasswordFile = config.sops.secrets."syncthing/gui_password".path;
    };
  };
}
