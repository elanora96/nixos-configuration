{ pkgs, ... }:
{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = [ "ertghiu256/qwen3-4b-code-reasoning" ];
      openFirewall = true;
    };

    open-webui = {
      enable = true;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    qwen-code
  ];
}
