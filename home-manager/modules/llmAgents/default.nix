{ inputs, pkgs, ... }:
let
  llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.herdr = {
    enable = true;
    package = llmPkgs.herdr;
  };

  services.hermes-agent = {
    enable = true;
    package = llmPkgs.hermes-agent;
  };

  home.packages = [
    llmPkgs.openspec
    llmPkgs.ccstatusline
    llmPkgs.git-surgeon
    llmPkgs.jscpd
  ];
}
