{
  inputs = {
    flakelight.url = "github:accelbread/flakelight";
    flakelight-darwin.url = "github:cmacrae/flakelight-darwin";
  };

  outputs =
    { flakelight, flakelight-darwin, ... }@inputs:
    flakelight ./. {
      inherit inputs;
      imports = [
        flakelight-darwin.flakelightModules.default
      ];
    };
}
