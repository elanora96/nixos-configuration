{ pkgs, ... }:
let
  inkscape-with-extensions = pkgs.inkscape-with-extensions.override {
    inkscapeExtensions = with pkgs.inkscape-extensions; [
      silhouette
      textext
    ];
  };
in
{
  home.packages = [ inkscape-with-extensions ];
}
