{
  description = "A very basic flake to control my universe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      home-manager-cfg-el = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users = {
            el = import ./home-manager/el-home.nix;
          };
        };
      };
    in
    {
      nixosConfigurations = {
        inanna = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules =
            [
              # local nixos module(s)
              ./nixos/inanna
            ]
            ++ [
              # Home-Manager
              home-manager.nixosModules.home-manager
              home-manager-cfg-el
            ]
            ++ [
              # nixos-hardware
              # R7 3700x
              nixos-hardware.nixosModules.common-cpu-amd
              nixos-hardware.nixosModules.common-cpu-amd-pstate
              nixos-hardware.nixosModules.common-cpu-amd-zenpower
              # SSDs
              nixos-hardware.nixosModules.common-pc-ssd
              # GTX 1070
              nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            ];
        };
      };
    };
}
