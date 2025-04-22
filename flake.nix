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
    inputs:
    let
      home-manager-cfg-el-full = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.el = import ./home-manager/el-home.nix;
        };
      };
      inanna = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Local system module
          ./nixos/inanna
          # Home-Manager + config
          inputs.home-manager.nixosModules.home-manager
          home-manager-cfg-el-full
          # Hardware modules
          ./hardware/cpu-amd-r7-3700x
          ./hardware/gpu-nvidia-gtx-1070 # Includes driver cfg
          inputs.nixos-hardware.nixosModules.common-pc-ssd
        ];
      };
    in
    {
      nixosConfigurations = {
        inherit inanna;
      };
    };
}
