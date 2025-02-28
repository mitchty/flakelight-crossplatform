# Flakelight-crossplatform
## About
Simple flakelight module for adding cross-platform modules for `darwin` and `nixos` systems.

## Quickstart

1) Add `flakelight-crossplatform` to your flakelight flake like so:

```
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

```

2) Add the cross-platform nix module(s) in the `flake.nix`, or use flakelight's folder autoload behavior and add the
modules as individual files under `nix/crossplatformModules` folder.

Note: the interface is the same as [nixosModules](https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md#nixosmodules-homemodules-and-flakelightmodules), except
we replace `nixosModule`/`nixosModules` with `crossplatformModule`/`crossplatformModules`.

e.g. Folder structure when using flakelight's folder autoload behavior:
```
.
├── crossplatformModules
│   └── example.nix
├── darwin
│   └── host1
│       ├── configuration.nix
│       └── default.nix
└── nixos
    └── host2
        ├── configuration.nix
        └── default.nix
```
 

3) Import the the cross-platform modules in the darwin and nixos host configurations.
e.g.

`nix/darwin/host1/default.nix`
```
{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.crossplatformModules.example
    ./configuration.nix
  ];
}
  
```

`nix/nixos/host2/default.nix`
```
{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.crossplatformModules.example
    ./configuration.nix
  ];
}
  
```

4) Rebuild hosts
```
darwin-rebuild switch --flake .#host1 
```
```
nixos-rebuild switch --flake .#host2
```

## Motivation
In my `flakelight` dotfiles, I have both `darwin` and `nixos` configurations defined for different macs and pcs I own.
Both of these confiurations use modules defined in the folders `darwinModules` and `nixosModules` respectively.  
However, I noticed that some of the configuration in the those modules can actually be shared between the two different type of systems.
(e.g. settings for `nix` such as `nix.gc.automatic`, `nix.settings`, etc.)

Here's an example to illustrate the problem and potential solutions:

### Example Problem
e.g. folder structure with duplicate `module-c` module:
```
.
├── flake.nix
└── nix
    ├── darwin
    │   └── host1
    │       ├── configuration.nix
    │       └── default.nix
    ├── darwinModules
    │   ├── module-a.nix
    │   └── module-c.nix
    ├── nixos
    │   └── host2
    │       ├── configuration.nix
    │       └── default.nix
    └── nixosModules
        ├── module-b.nix
        └── module-c.nix
```

`nix/darwin/host1/default.nix`
```
{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    inputs.self.darwinModules.module-c
    ./configuration.nix
  ];
}
```

`nix/nixos/host2/default.nix`
```
{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    inputs.self.nixosModules.module-c
    ./configuration.nix
  ];
}
```

### Potential Solution

See how `inputs.self.nixosModules.example` is duplicated in both the `nixosModules` and the `darwinModules` folder.
First step we can try to share the common module files is to move them to a `crossplatformModules` folder.

Folder structure with addition of `crossplatformModules` folder:
```
.
├── flake.lock
├── flake.nix
└── nix
    ├── crossplatformModules
    │   └── module-c.nix
    ├── darwin
    │   └── host1
    │       ├── configuration.nix
    │       └── default.nix
    ├── darwinModules
    │   └── module-a.nix
    ├── nixos
    │   └── host2
    │       ├── configuration.nix
    │       └── default.nix
    └── nixosModules
        └── module-b.nix
```

Now, we'll have to import these via relative file paths:

`nix/darwin/host1/default.nix`
```
{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    ../../crossplatformModules/module-c.nix
    ./configuration.nix
  ];
}
```

`nix/nixos/host2/default.nix`
```
{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    ../../crossplatformModules/module-c.nix
    ./configuration.nix
  ];
}
```

#### Pros
- Simple, no need for additional tooling

#### Cons
- Have to maintain relative file references
- Not as consistent with pattern of using `inputs.self...` for including re-usable modules.


### Refining the solution 
We can refine the solution to support importing with the `inputs.self...`
convention in our host configurations.

We'll update the `flake.nix` to include our flakelight-crossplatform module:
```
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
        flakelight-crossplatform.flakelightModules.default  # Added flakelight module here
        flakelight-darwin.flakelightModules.default 
      ];
    }
 }
  
```

Now we can update the host configurations:

`nix/darwin/host1/default.nix`
```
{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    ../../crossplatformModules/module-c.nix
    ./configuration.nix
  ];
}
```

`nix/nixos/host2/default.nix`
```
{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    ../../crossplatformModules/module-c.nix
    ./configuration.nix
  ];
}
```

#### Pros
- Can follow the `inputs.self...` import convention in our host configurations

#### Cons
- Need to add a dependecny on an external flakelight module 


### Summary
Hopefully the above shows why I created this flakelight module. 
In short, the main motivation is to avoid duplication in my darwin and nixos configurations.
