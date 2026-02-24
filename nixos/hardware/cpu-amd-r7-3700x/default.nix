{ inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    # Enables the amd cpu scaling https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # Enables the zenpower sensor in lieu of the k10temp sensor on Zen CPUs https://git.exozy.me/a/zenpower3
    # On Zen CPUs zenpower produces much more data entries
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
  ];
}
