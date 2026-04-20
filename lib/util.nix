/**
  General Nix utilities
*/
{ lib, ... }:
{
  /**
    Return the contents of a directory path `dir` as an attribute set mapping filenames to the corresponding file's path

    # Inputs

    `dir`
    : A path containing nix modules

    # Type

    ```
    readModuleDir :: Path -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `util.readModuleDir` usage example

    ```nix
    readModuleDir ./nixos/modules
    =>
    {
      common-nix = /home/el/Projects/nixos-configuration/nixos/modules/common-nix.nix;
      home-assistant = /home/el/Projects/nixos-configuration/nixos/modules/home-assistant.nix;
      ...
    }
    ```
  */
  readModuleDir =
    dir:
    let
      filteredList = builtins.filter (name: lib.hasSuffix ".nix" name) (
        builtins.attrNames (builtins.readDir dir)
      );
    in
    lib.listToAttrs (
      map
        # Remove file ext for name, add dir to value
        (fileName: lib.nameValuePair (lib.removeSuffix ".nix" fileName) (dir + "/${fileName}"))
        filteredList
    );

  /**
    Return the last subpath

    # Inputs

    `path`
    : A non-empty path

    # Type

    ```
    lastSubpath :: Path -> String
    ```

    # Examples
    :::{.example}
    ## `util.lastSubpath` usage example

    ```nix
    lastSubpath ./nixos/modules
    =>
    "modules"
    ```
  */
  lastSubpath =
    path:
    let
      inherit (lib.path.splitRoot path) subpath;
    in
    lib.last (lib.path.subpath.components subpath);
}
