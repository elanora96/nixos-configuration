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

      secrets = {
        "ROMM_ENVIRONMENT_FILE" = {
          sopsFile = secretsFolderPath + /romm.env;
          format = "dotenv";
        };
        "wireguard_conf" = {
          sopsFile = secretsFolderPath + /wireguard.conf;
          format = "binary";
          group = "media";
          mode = "0440";
        };
      };
    };
}
