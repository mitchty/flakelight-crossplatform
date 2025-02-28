{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.crossplatformModules.example
    ./configuration.nix
  ];
}
