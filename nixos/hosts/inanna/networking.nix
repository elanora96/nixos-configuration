{ pkgs, ... }:
{
  networking = {
    hostName = "inanna";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [
        8000
        8080
        3030
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
