util:

{ lib, ... }:
{
  /**
    Return the contents of the directory path as a set mapping directory filenames to the corresponding file's path.
  */
  readDirAttrs =
    dir:
    # TODO: Check if there is function that does this better
    # Remove file ext for key, add it back for value
    lib.genAttrs (map (lib.removeSuffix ".nix")
      # Get filenames in dir
      (builtins.attrNames (builtins.readDir dir))
    ) (name: dir + "/${name}.nix");
}
