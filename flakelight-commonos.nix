{
  config,
  lib,
  flakelight,
  moduleArgs,
  ...
}:
let
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) lazyAttrsOf;
  inherit (flakelight.types) module nullable optCallWith;
in
{
  options = {
    commonosModule = mkOption {
      type = nullable module;
      default = null;
    };

    commonosModules = mkOption {
      type = optCallWith moduleArgs (lazyAttrsOf module);
      default = { };
    };
  };

  config = mkMerge [
    (mkIf (config.commonosModule != null) {
      commonosModules.default = config.commonosModule;
    })

    (mkIf (config.commonosModules != { }) {
      outputs = { inherit (config) commonosModules; };
    })
  ];
}
