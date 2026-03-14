{ pkgs, ... }:
{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = [ "qwen3.5:9b" ];
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
