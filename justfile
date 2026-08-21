type := `grep -q 'NAME=NixOS' /etc/*-release && echo "os" || echo "home"`

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

# Get soppy with it
[group('main')]
sop:
    sops ./secrets/secrets.yaml

# Rebuild and switch
[group('main')]
switch:
    sudo nixos-rebuild switch --flake . --show-trace

# List generations
[group('main')]
gens:
    {{ if type == "os" { "nixos-rebuild list-generations" } else { "home-manager generations" } }}

# Misc
# ---

# https://discourse.nixos.org/t/why-doesnt-nix-collect-garbage-remove-old-generations-from-efi-menu/17592/4
[group('misc')]
cleanEFI:
    sudo nix-collect-garbage -d
    sudo /run/current-system/bin/switch-to-configuration boot
