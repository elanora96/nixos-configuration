{
  description = "Flake based nixos config(s)";

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
    nixvim.url = "github:nix-community/nixvim";

    # treefmt for nix
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.home-manager.flakeModules.home-manager
      ];
      perSystem = _: {
        debug = true;
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            deadnix.enable = true;
            mdformat.enable = true;
            nixfmt.enable = true;
            statix.enable = true;
          };
        };
      };
      flake =
        _:
        let
          nixosModules = {
            # Enables unfree packages, nix command, and flakes
            common-nix = ./nixos/modules/common-nix.nix;
            # Just kde
            graphical = ./nixos/modules/graphical.nix;
            # Selfhosting things
            homelab = ./nixos/modules/homelab.nix;
            # Networking
            openssh = ./nixos/modules/openssh.nix;
            printing = ./nixos/modules/printing.nix;
            tailscale = ./nixos/modules/tailscale.nix;
            # Home-Manager
            hm = inputs.home-manager.nixosModules.home-manager;
            # Host inanna specific
            inanna-modules = {
              system-module = ./nixos/hosts/inanna;
              hm-cfg = {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.el = import ./home-manager/hosts/inanna.nix;
                };
              };
            };
          };
        in
        {

          nixosConfigurations = {
            # My primary desktop system
            inanna = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = {
                inherit inputs;
              };
              modules = with nixosModules; [
                common-nix
                graphical
                homelab
                openssh
                printing
                tailscale
                hm
                inanna-modules.system-module
                inanna-modules.hm-cfg
              ];
            };
          };

        };
    };
}
