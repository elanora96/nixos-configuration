# just --list
[group('default')]
default:
    @just --list

# Main Commands
# ---

# Update flake inputs
[group('main')]
update:
    nix flake update

# Rebuild and switch
[group('main')]
switch:
    sudo nixos-rebuild switch --flake . --show-trace

# Misc
# ---

# https://discourse.nixos.org/t/why-doesnt-nix-collect-garbage-remove-old-generations-from-efi-menu/17592/4
[group('misc')]
cleanEFI:
    sudo nix-collect-garbage -d
    sudo /run/current-system/bin/switch-to-configuration boot
