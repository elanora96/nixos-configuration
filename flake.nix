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

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    let
      nixosModules = {
        # Enables unfree packages, nix command, and flakes
        common-nix = ./nixos/modules/common-nix.nix;
        # Just kde
        graphical = ./nixos/modules/graphical.nix;
        # Selfhosting things
        homelab = ./nixos/modules/homelab.nix;
        traefik = ./nixos/modules/traefik.nix;
        # Networking
        openssh = ./nixos/modules/openssh.nix;
        printing = ./nixos/modules/printing.nix;
        tailscale = ./nixos/modules/tailscale.nix;
        # Home-Manager
        hm = inputs.home-manager.nixosModules.home-manager;
        # Nur overlay
        nur = inputs.nur.modules.nixos.default;
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
          traefik
          hm
          nur
          inanna-modules.system-module
          inanna-modules.hm-cfg
        ];
      };
    in
    {
      nixosConfigurations = {
        inherit inanna;
      };

      # formatter = inputs.nixpkgs.legacyPackages.${system}.treefmt.withConfig {
      #      runtimeInputs = with pkgs; [
      #        nixfmt
      #        deadnix
      #        keep-sorted
      #      ];
      #      settings = pkgs.lib.importTOML ./treefmt.toml;
      #    };
    };
}
