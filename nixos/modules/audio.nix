{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # for pactl
    pulseaudio
    pamixer
    # for jack
    pipewire.jack
  ];

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;

      # Airplay
      # opens UDP ports 6001-6002
      raopOpenFirewall = true;
      extraConfig.pipewire = {
        "10-airplay" = {
          "context.modules" = [
            {
              name = "libpipewire-module-raop-discover";

              # increase the buffer size if you get dropouts/glitches
              # args = {
              #   "raop.latency.ms" = 500;
              # };
            }
          ];
        };
      };
    };
  };

  # Allows Pipewire to use the realtime scheduler
  security.rtkit.enable = true;
}
