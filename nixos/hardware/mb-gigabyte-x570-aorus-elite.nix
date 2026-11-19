{ inputs, ... }:
let
  # Gigabyte Aorus Elite X570 uses the `it8688`
  sensorModule = "it87";
  modprobeOptions = {
    "ignore_resource_conflicts" = 1;
    "force_id" = "0x8688";
  };
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    # Enables the amd cpu scaling https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # Enables the zenpower sensor in lieu of the k10temp sensor on Zen CPUs https://git.exozy.me/a/zenpower3
    # On Zen CPUs zenpower produces much more data entries
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
  ];

  boot = {
    kernelModules = [ sensorModule ];
    extraModprobeConfig =
      let
        modprobeOptionsString = builtins.concatStringsSep " " (
          builtins.attrValues (builtins.mapAttrs (name: value: "${name}=${toString value}") modprobeOptions)
        );
      in
      ''
        options ${sensorModule} ${modprobeOptionsString}
      '';
  };
}
