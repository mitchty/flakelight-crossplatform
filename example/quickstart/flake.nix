{
  inputs = {
    flakelight.url = "github:accelbread/flakelight";
    flakelight-darwin.url = "github:cmacrae/flakelight-darwin";
    flakelight-crossplatform.url = "github:rencire/flakelight-crossplatform";
  }

  outputs =
    {
      flakelight,
      flakelight-crossplatform,
      flakelight-darwin,
      ...
    }@inputs:
    flakelight ./. {
      inherit inputs;
      imports = [
        flakelight-crossplatform.flakelightModules.default
        flakelight-darwin.flakelightModules.default
      ];
    }
 }
