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

    # Integration of pre-commit git hooks with Nix
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        systems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-linux"
        ];
        imports = [
          inputs.git-hooks-nix.flakeModule
          inputs.home-manager.flakeModules.home-manager
          inputs.treefmt-nix.flakeModule
        ];
        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          let
            hm-users = {
              el = {
                graphical = ./home-manager/el/graphical.nix;
                minimal = ./home-manager/el/minimal.nix;
              };
            };

            extraSpecialArgs = { inherit inputs; };
          in
          {
            debug = true;
            # pkgs config
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ ];
              config.allowUnfree = true;
            };
            legacyPackages.homeConfigurations = {
              el-minimal = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs extraSpecialArgs;
                modules = [
                  hm-users.el.minimal
                ];
              };
              el-graphical = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs extraSpecialArgs;
                modules = [
                  hm-users.el.graphical
                ];
              };
            };
            pre-commit = {
              check.enable = true;
              settings.hooks = {
                treefmt.enable = true;
              };
            };
            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                deadnix.enable = true;
                just.enable = true;
                keep-sorted.enable = true;
                mdformat.enable = true;
                nixfmt.enable = true;
                statix.enable = true;
              };
            };
            devShells.default = pkgs.mkShell {
              name = "nixos-configurations-shell";
              inputsFrom = [
                config.treefmt.build.devShell
                config.pre-commit.devShell
              ];
              packages = [
                pkgs.just
              ];
            };
          };
        flake =
          let
            inherit (import ./lib/util.nix { inherit (inputs.nixpkgs) lib; }) readDirAttrs;

            nixosModules = {
              # keep-sorted start block=yes
              # Host inanna specific
              hosts = {
                inanna = {
                  system = ./nixos/hosts/inanna;
                  home.home-manager.users.el = import ./home-manager/hosts/inanna.nix;
                };
              };
              withSystem-pkg-cfg =
                { config, ... }:
                {
                  # Use the configured pkgs from perSystem
                  nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system (
                    { pkgs, ... }: # perSystem module arguments
                    pkgs
                  );
                };
              # keep-sorted end
            }
            // readDirAttrs ./nixos/modules;

            specialArgs = { inherit inputs; };
          in
          {
            nixosConfigurations = {
              # keep-sorted start block=yes
              # My primary desktop system
              inanna = inputs.nixpkgs.lib.nixosSystem {
                inherit specialArgs;
                modules = with nixosModules; [
                  # keep-sorted start
                  common-nix
                  home-assistant
                  home-manager
                  homelab
                  hosts.inanna.home
                  hosts.inanna.system
                  inputs.sops-nix.nixosModules.sops
                  kde
                  llm
                  openssh
                  printing
                  tailscale
                  withSystem-pkg-cfg
                  # keep-sorted end
                ];
              };
              # keep-sorted end
            };
          };
      }
    );
}
