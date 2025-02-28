{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    inputs.self.crossplatformModules.module-c
    ./configuration.nix
  ];
}
