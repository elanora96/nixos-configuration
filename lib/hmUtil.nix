/**
  Utilities for Home Manager tend to require more inputs than general Nix utils
  Thus split to a seperate file to make importing general utils easier
*/
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  util = import ./util.nix { inherit lib; };
in
{
  /**
    Generates a homeManagerConfiguration from a user module's path

    # Inputs

    `userModulePath`
    : A path to a Home Manager module

    # Type

    ```
    mkHMCfg :: Path -> AttrSet
    ```

    # Examples
    :::{.example}
    ## `hmUtil.mkHMCfg` usage example

    ```nix
    mkHMCfg ./home-manager/el/minimal.nix
    =>
    {
      _module = { ... };
      _type = "configuration";
      ...
    }
    ```
  */
  mkHMCfg =
    userModulePath:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        userModulePath
      ];
    };

  /**
      Return the contents of a a user's Home Manager modules directory path `userModuleDir` as an attribute set mapping username-modulename to the corresponding module's file path

      # Inputs

      `userModuleDir`
      : A path containing a user's Home Manager modules

      # Type

      ```
      readHMUserModuleDir :: Path -> AttrSet
      ```

      # Examples
      :::{.example}
      ## `hmUtil.readHMUserModuleDir` usage example

      ```nix
      readHMUserModuleDir ./home-manager/el
      =>
      {
        el-graphical = /home/el/Projects/nixos-configuration/home-manager/el/graphical.nix;
        el-minimal = /home/el/Projects/nixos-configuration/home-manager/el/minimal.nix;
      }
      ```
  */
  readHMUserModuleDir =
    userModuleDir:
    let
      userName = util.lastSubpath userModuleDir;
      userModuleDirAttrSet = util.readModuleDir userModuleDir;
    in
    lib.mapAttrs' (
      fileName: filePath: lib.nameValuePair "${userName}-${fileName}" filePath
    ) userModuleDirAttrSet;
}
