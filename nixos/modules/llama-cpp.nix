{ config, pkgs, ... }:
let
  inherit (config) homelab;
  cfg = config.services.llama-cpp;
  LLAMA_CPP_DOMAIN = "llama-cpp.${homelab.domain}";
  package =
    (pkgs.llama-cpp.override {
      cudaSupport = true;
      # Needed for Pascal
      cudaPackages = pkgs.cudaPackages_12;
    }).overrideAttrs
      (
        _final: _prev: {
          cmakeFlags =
            let
              inherit (pkgs.lib) cmakeFeature cmakeBool;
              # Pascal arch string does not appear in
              # cudaPackages_12.flags.cmakeCudaArchitecturesString
              cudaArchPascal = "61";
              # Upstream reads these from git, which the release tarball does not ship.
              # They are purely informational: `llama-server --version`, `/props`, and the web UI.
              buildNumber = "11146";
              buildCommit = "7fe450e";
            in
            [
              (cmakeBool "GGML_NATIVE" false)
              (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
              (cmakeBool "LLAMA_BUILD_SERVER" true)
              (cmakeBool "LLAMA_BUILD_TESTS" false)
              (cmakeBool "LLAMA_BUILD_IS_DEV" false)
              (cmakeBool "LLAMA_OPENSSL" true)
              (cmakeBool "BUILD_SHARED_LIBS" true)
              (cmakeBool "GGML_CUDA" true)
              (cmakeFeature "LLAMA_BUILD_NUMBER" buildNumber)
              (cmakeFeature "LLAMA_BUILD_COMMIT" buildCommit)
              (cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchPascal)
            ];
        }
      );

in
{
  environment.systemPackages = [
    package
  ];

  services.llama-cpp = {
    inherit package;
    enable = true;
    settings.models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      "LFM2.5-8B-A1B" = {
        hf-repo = "unsloth/LFM2.5-8B-A1B-GGUF";
        hf-file = "LFM2.5-8B-A1B-UD-Q4_K_XL.gguf";
        alias = "unsloth/LFM2.5-8B-A1B-GGUF";
        temp = "0.2";
        repeat-penalty = "1.05";
        top-k = "80";
      };
    };
  };

  services.nginx.virtualHosts.${LLAMA_CPP_DOMAIN} = {
    forceSSL = true;
    useACMEHost = homelab.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.settings.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
    };
  };
}
