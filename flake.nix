{
  description = "elanora96's flake based nixos config(s)";

  inputs = {
    # (Unstable) Nix Packages collection
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NixOS modules covering hardware quirks
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Manage a user environment using Nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My preferred flake framework
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # nixvim - Configure Neovim with Nix!
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # treefmt for nix
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Atomic secret provisioning based on sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # aarch64 and x86_64 for linux and darwin
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        systems = import inputs.systems;
        imports = [
          inputs.treefmt-nix.flakeModule
          inputs.home-manager.flakeModules.home-manager
        ];
        perSystem =
          { system, ... }:
          {
            debug = true;
            # pkgs config
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ ];
              config.allowUnfree = true;
            };
            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                deadnix.enable = true;
                keep-sorted.enable = true;
                mdformat.enable = true;
                nixfmt.enable = true;
                statix.enable = true;
              };
            };
          };
        flake =
          { lib, ... }:
          let
            nixosModulesFolder = lib.genAttrs (map (lib.removeSuffix ".nix") (
              builtins.attrNames (builtins.readDir ./nixos/modules)
            )) (name: ./nixos/modules + "/${name}.nix");

            nixosModules = nixosModulesFolder // {
              # keep-sorted start block=yes
              # Host inanna specific
              inanna-modules = {
                system-module = ./nixos/hosts/inanna;
                hm-cfg = {
                  home-manager.users.el = import ./home-manager/hosts/inanna.nix;
                };
              };
              # Use with System to config pkgs
              package-cfg =
                { config, ... }:
                {
                  # Use the configured pkgs from perSystem
                  nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system (
                    { pkgs, ... }: # perSystem module arguments
                    pkgs
                  );
                };
              # keep-sorted end
            };
          in
          {
            nixosConfigurations = {
              # keep-sorted start block=yes
              # My primary desktop system
              inanna = inputs.nixpkgs.lib.nixosSystem {
                specialArgs = {
                  inherit inputs;
                };
                modules = with nixosModules; [
                  # keep-sorted start
                  common-nix
                  home-manager
                  homelab
                  inanna-modules.hm-cfg
                  inanna-modules.system-module
                  inputs.sops-nix.nixosModules.sops
                  kde
                  llm
                  openssh
                  package-cfg
                  printing
                  tailscale
                  # keep-sorted end
                ];
              };
              # keep-sorted end
            };
          };
      }
    );
}
