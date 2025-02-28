# WIP
# Flakelight-commonos
## What is this?
Simple flakelight module for adding common modules for `darwin` and `nixos` systems.

## How to use?




## Why create this?

### Problem
In my `flakelight` dotfiles, I have both `darwin` and `nixos` configurations defined for different macs and pcs I own.
Both of these confiurations use modules defined in the folders `darwinModules` and `nixosModules` respectively.  
However, I noticed that some of the configuration in the those modules can actually be shared between the two different type of systems.


e.g. folder structure with duplicate `module-c`
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

`flake.nix`
```

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

### Potential Solution 1

See how `inputs.self.nixosModules.example` is duplicated in both the `nixosModules` and the `darwinModules` folder.
First step we can try to share the common module files is to move them to a `commonosModules` folder.

e.g. folder structure with addition of `commmonModules` folder:
```

```

Now, we'll have to import these via relative file paths:

e.g. `nix/darwin/host1/default.nix`
```
{ inputs, ... }:
{
  system = "aarch64-darwin";
  modules = [
    inputs.self.darwinModules.module-a
    ../../commonosModules/module-c.nix
    ./configuration.nix
  ];
}
```

e.g. `nix/nixos/host2/default.nix`
```
{ inputs, ... }:
{
  system = "x86_64-linux";
  modules = [
    inputs.self.nixosModules.module-b
    ../../commonosModules/module-c.nix
    ./configuration.nix
  ];
}
```

### Pros
- Simple, no need for additional tooling

### Cons
- Have to maintain relative file references
- Not as consistent with pattern of using `inputs.self...` for including re-usable modules.

< pre>< del>
## Potential Solution 2
The above is an ok solution.  However, I don't like maintaining relative paths if I need to move folders and files around.  Also, I prefer to use the same `inputs.self.<modules_folder>.<module_name>`.
Hence, I created a simple flakelight module to support using the `inputs.self...` import pattern.
We can add the flakelight module like so:

`flake.nix`
```
  
```

Now we can add `commonosModules` folder, for nix modules that can be shared
between `darwin` and `nixos` configurations (in this case, module-c.nix):
< /del>< /pre>
