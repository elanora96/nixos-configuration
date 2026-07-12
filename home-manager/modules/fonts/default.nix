{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "ttf-derivation";
  version = "0.1.0";

  src = ./truetype;

  installPhase =
    let
      ttfOutDir = "$out/share/fonts/truetype";
    in
    ''
      runHook preInstall

      install -D --mode 444 *.ttf --target-directory ${ttfOutDir}

      runHook postInstall
    '';

  meta = {
    description = "Simple derivation of ttfs I want";
  };
}
