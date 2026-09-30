{ config, ... }:
{
  services = {
    open-webui = {
      enable = false;
      port = 8182; # The audacity for the default port to be 8080
      environment =
        let
          inherit (config.services.llama-cpp.settings) host port;
        in
        {
          OLLAMA_API_BASE_URL = "http://${host}:${toString port}/api";
          WEBUI_AUTH = "False";
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "qwen3-embedding:0.6b";
        };
    };
  };
}
