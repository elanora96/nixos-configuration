{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
  inherit (config) region;
in
{
  options.region = mkOption {
    type = types.str;
    default = "us-westcoast";
  };

  config = mkIf (region == "us-westcoast") {
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
  };
}
