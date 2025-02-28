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
    crossplatformModule = mkOption {
      type = nullable module;
      default = null;
    };

    crossplatformModules = mkOption {
      type = optCallWith moduleArgs (lazyAttrsOf module);
      default = { };
    };
  };

  config = mkMerge [
    (mkIf (config.crossplatformModule != null) {
      crossplatformModules.default = config.crossplatformModule;
    })

    (mkIf (config.crossplatformModules != { }) {
      outputs = { inherit (config) crossplatformModules; };
    })
  ];
}
