{ inputs, pkgs, ... }:
let
  inherit (inputs.stylix.inputs) tinted-schemes;
  # https://tinted-theming.github.io/tinted-gallery/
  getTintedScheme = schemeName: "${tinted-schemes}/base16/${schemeName}.yaml";
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;

    polarity = "dark";
    base16Scheme = getTintedScheme "catppuccin-macchiato";

    fonts = {
      serif = {
        package = pkgs.texlivePackages.bitter;
        name = "Bitter";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      monospace = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };

      emoji = {
        package = pkgs.serenityos-emoji-font;
        name = "SerenityOS Pixel Emoji";
      };

      sizes = {
        desktop = 11;
        popups = 11;
        applications = 11;
        terminal = 11;
      };
    };

    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };
  };
}
