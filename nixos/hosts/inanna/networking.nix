{ pkgs, ... }:
{
  networking = {
    hostName = "inanna";
    networkmanager.enable = true;
    nftables = {
      enable = true;
      tables."mullvad-tailscale" = {
        family = "inet";
        content = ''
          chain prerouting {
            type filter hook prerouting priority -100; policy accept;
            ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            udp dport 41641 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            # Allow incoming UDP on Tailscale port to bypass Mullvad
            udp dport 41641 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }

          chain outgoing {
            type route hook output priority -100; policy accept;
            meta mark 0x80000 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            # Allow outgoing UDP from Tailscale port to bypass Mullvad
            udp sport 41641 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }
        '';
      };
    };

    firewall = {
      allowedTCPPorts = [
        80
        443
        8000
        8080
        3030
        7470
      ];
    };
  };

  services = {
    mullvad-vpn = {
      enable = true;
      # GUI package
      package = pkgs.mullvad-vpn;
    };

    resolved.enable = true;
  };
}
