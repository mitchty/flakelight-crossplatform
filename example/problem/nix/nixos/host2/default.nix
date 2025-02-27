{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    inputs.self.nixosModules.module-c
    ./configuration.nix
  ];
}
