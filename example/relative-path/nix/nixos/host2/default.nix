{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    ../../commonosModules/module-c.nix
    ./configuration.nix
  ];
}
