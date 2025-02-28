{
  inputs = {
    flakelight.url = "github:accelbread/flakelight";
    flakelight-darwin.url = "github:cmacrae/flakelight-darwin";
    flakelight-crossplatform.url = "github:rencire/flakelight-crossplatform";
  };

  outputs =
    {
      flakelight,
      flakelight-darwin,
      flakelight-crossplatform,
      ...
    }@inputs:
    flakelight ./. {
      inherit inputs;
      imports = [
        flakelight-darwin.flakelightModules.default
        flakelight-crossplatform.flakelightModules.default
      ];
    };
}
