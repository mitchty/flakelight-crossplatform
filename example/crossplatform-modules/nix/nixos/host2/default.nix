{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    inputs.self.crossplatformModules.module-c
    ./configuration.nix
  ];
}
