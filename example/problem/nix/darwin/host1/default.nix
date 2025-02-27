{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    inputs.self.darwinModules.module-c
    ./configuration.nix
  ];
}
