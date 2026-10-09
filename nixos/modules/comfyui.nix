{ config, ... }:
let
  inherit (config) homelab;
  COMFYUI_DOMAIN = "comfyui.${homelab.domain}";
in
{
  services = {
    comfyui = {
      enable = true;
      models =
        let
          modelInstallPaths = {
            generationModels = "generation_models";
            upscaleModels = "upscale_models";
          };
          RealESRGAN = {
            name = "RealESRGAN_x4plus_anime_6B.pth";
            url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth";
            hash = "sha256-+HLYN9PJDtLgUie+1xGvVnGm/RyffX6RyRGmHxVemdo=";
            installPaths = modelInstallPaths.upscaleModels;
          };
          Qwen-Image = {
            name = "Qwen-Image-2.1";
            url = "https://huggingface.co/abenzerps/Qwen-Image-2.1-Uncensored-GGUF/blob/main/qwen-image-2.1-UC-Q4_K_M.gguf";
            hash = "sha256-On9Bq48WPC2O8RogFXYIYNYyfE9v4YIKqdYfn2CyZFs=";
            installPaths = modelInstallPaths.generationModels;
          };
        in
        [
          RealESRGAN
          Qwen-Image
        ];
    };
  };

  services.nginx.virtualHosts.${COMFYUI_DOMAIN} =
    let
      cfg = config.services.comfyui;
    in
    {
      forceSSL = true;
      useACMEHost = homelab.domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
      };
    };
}
