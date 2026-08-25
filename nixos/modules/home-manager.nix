{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-bak-${inputs.self.lastModifiedDate}";
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];
}
