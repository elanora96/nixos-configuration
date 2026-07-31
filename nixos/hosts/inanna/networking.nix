_: {
  networking = {
    hostName = "inanna";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts =
        let
          nicotinePlus = 2236;
          iThinkTheseWereForDevelopment = [
            3030
            8000
            8080
          ];
        in
        [
          nicotinePlus
        ]
        ++ iThinkTheseWereForDevelopment;
    };
  };

  services = {
    mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };

    resolved.enable = true;
  };
}
