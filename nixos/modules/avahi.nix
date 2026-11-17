_: {
  # Required for Airplay, iDescriptor, and other service discovery
  services.avahi = {
    enable = true;
    openFirewall = true;
    settings = {
      reflector.enable-reflector = true;
      publish = {
        disable-publishing = false;
        publish-addresses = true;
      };
    };
  };
}
