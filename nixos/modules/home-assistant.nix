{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [
    config.services.home-assistant.config.http.server_port
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"

      # User chosen components
      "snapcast"
      "opower"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
  };
}
