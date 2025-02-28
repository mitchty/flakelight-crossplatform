{
  inputs = {
    flakelight.url = "github:accelbread/flakelight";
    flakelight-darwin.url = "github:cmacrae/flakelight-darwin";
    flakelight-crossplatform.url = "github:rencire/flakelight-crossplatform"; # Added
  }

  outputs =
    {
      flakelight,
      flakelight-crossplatform, # Added
      flakelight-darwin, 
      ...
    }@inputs:
    flakelight ./. {
      inherit inputs;
      imports = [
        flakelight-crossplatform.flakelightModules.default  # Added 
        flakelight-darwin.flakelightModules.default 
      ];
    }
 }
