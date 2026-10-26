# nixtants

`Nixtants` is a Nix flake for managing constants.

Essentially, a free-form constants management system.

## How to use

First import it into your flake inputs as follows:

```Nix
{
    inputs = {
        inputs.nixtants.url = "github:givikuna/nixtants";
    }
}
```

Or use the Codeberg mirror:

```Nix
{
    inputs = {
        inputs.nixtants.url = "git+https://codeberg.org/giviko/nixtants";
    }
}
```

Also make sure you have an input for `nixpkgs`.

In your outputs do as follows:

```Nix
{
    outputs = inputs: {
        nixosConfigurations = {
            nixos = inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix

                    inputs.nixtants.nixosModules.default
                    ./nixtants

                    # if you have home manager:
                    {
                        home-manager.sharedModules = [
                            inputs.nixtants.homeModules.default
                            ./nixtants
                        ];
                    }
                ];
                specialArgs = { inherit inputs; };
            }
        };
    }
}
```

Make a folder at `/etc/nixos` called `nixtants`:
Then create a `default.nix` file.

You can then declare any information in it like this:

```Nix
{
  nixtants.users.givik.codeberg = {
    username = "giviko";
    email = "gvtsvariani@gmail.com";
  };
}
```

You can also declare these in different files (within the same folder) and simply import them as follows:

Consider the file tree:

```BASH
| .
└── | nixtants
    ├── | codeberg
    │   └── | default.nix
    └── | default.nix
```

In `./nixtants/codeberg/default.nix` you can put:

```Nix
{
  nixtants.users.givik.codeberg = {
    username = "giviko";
    email = "gvtsvariani@gmail.com";
  };
}
```

And in `./nixtants/default.nix`:

```Nix
{
    imports = [
        ./codeberg/default.nix
    ];

    nixtants.users.givik.username = "givik";

    nixtants.random-constant.whatever = 1;
}
```

You can now import it into any home manager or NixOS module as `nixtants`:

Consider this home-manager module:

```Nix
{ nixtants, pkgs, ... }: {
    programs.git = {
        enable = true;

        settings = {
            user = {
                name  = nixtants.users.givik.username;
                email = nixtants.users.givik.email;
            };
        };
    };
}
```

## Hacking

This flake is very hackable.

You can easily change the name of the nixtants folder to something else:

### Changing Folder Name

This can be done easily by simply changing the name of the folder, and importing a different name instead of `./nixtants`:

Assume you have the file structure for `nixtants` as:

```BASH
| .
└── | constants
    ├── | codeberg
    │   └── | default.nix
    └── | default.nix
```

Now you simply import `./constants` instead as follows in your flake:

```Nix
{
    outputs = inputs: {
        nixosConfigurations = {
            nixos = inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix

                    inputs.nixtants.nixosModules.default
                    ./constants # used to be ./nixtants

                    # if you have home manager:
                    {
                        home-manager.sharedModules = [
                            inputs.nixtants.homeModules.default
                            ./constants # used to be ./nixtants
                        ];
                    }
                ];
                specialArgs = { inherit inputs; };
            }
        };
    }
}
```

### Changing Nixtants Module Name

### Continuation

You can mess with this flake and its functionality a lot.
It is a very simple flake on purpose.

Feel free to fork it, clone it, or anything of the sorts.
