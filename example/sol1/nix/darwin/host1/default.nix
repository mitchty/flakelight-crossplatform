{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    ../../commonosModules/module-c.nix
    ./configuration.nix
  ];
}
