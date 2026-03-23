{ pkgs, ... }:
{
  services = {
    snapserver = {
      enable = true;
      settings = {
        stream.source = "pipe:///run/snapserver/pipe?name=NAME";
      };
      openFirewall = true;
    };
    pipewire.extraConfig.pipewire-pulse."40-snapcast-sink" = {
      "pulse.cmd" = [
        {
          cmd = "load-module";
          args = "module-pipe-sink file=/run/snapserver/pipe sink_name=Snapcast format=s16le rate=48000";
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
