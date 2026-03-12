_util:

{ lib, ... }:
{
  /**
    Return the contents of the directory path as a set mapping directory filenames to the corresponding file's path.
  */
  readDirAttrs =
    dir:
    lib.listToAttrs (
      map
        # Remove file ext for name, add dir to value
        (fileName: lib.nameValuePair (lib.removeSuffix ".nix" fileName) (dir + "/${fileName}"))
        # Get filenames in dir
        (builtins.attrNames (builtins.readDir dir))
    );
}
