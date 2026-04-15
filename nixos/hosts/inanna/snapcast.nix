{ pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      openFirewall = true;
      reflector = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    snapserver = {
      enable = true;
      settings = {
        stream.source = "pipewire:///run/snapserver/pipe?name=Snapcast";
      };
      openFirewall = true;
    };
    pipewire.extraConfig.pipewire-pulse."40-snapcast-sink" = {
      "pulse.cmd" = [
        {
          cmd = "load-module";
          args = "module-pipe-sink file=/run/snapserver/pipe sink_name=SnapcastPipe format=s16le rate=48000";
        }
      ];
    };
  };
  systemd.user.services.snapclient-local = {
    wantedBy = [
      "pipewire.service"
    ];
    after = [
      "pipewire.service"
    ];
    serviceConfig = {
      ExecStart = "${pkgs.snapcast}/bin/snapclient --player pipewire tcp://localhost:1704";
    };
  };
}
