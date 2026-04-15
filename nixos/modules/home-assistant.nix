{ config, ... }:
let
  homekit = {
    TCPPort = 21063;
    UDPPort = 5353;
  };
in
{
  networking.firewall = {
    allowedTCPPorts = [
      config.services.home-assistant.config.http.server_port
      homekit.TCPPort
    ];
    allowedUDPPorts = [ homekit.UDPPort ];
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"

      # User chosen components
      # keep-sorted start
      "homekit"
      "jellyfin"
      "opower"
      "snapcast"
      # keep-sorted end
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
      logger = {
        default = "WARNING";
        logs = {
          homeassistant.components.homekit = "DEBUG";
          pyhap = "DEBUG";
        };
      };
    };
  };
}
