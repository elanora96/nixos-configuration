{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops =
    let
      secretsFolderPath = ../../secrets;
    in
    {
      defaultSopsFile = secretsFolderPath + /secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/home/el/.config/sops/age/keys.txt";

      secrets."wireguard_conf" = {
        sopsFile = secretsFolderPath + /wireguard.ini;
        format = "ini";
      };
    };
}
