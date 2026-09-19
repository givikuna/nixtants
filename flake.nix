{
  description = "nixtants - a global free-form namespace";

  outputs =
    { self }:
    let
      mkNixtants = { lib, config, ... }: {
        options.nixtants = lib.mkOption {
          type = lib.types.mkOptionType {
            name = "nixtants";
            description = "free-form namespace";
            check = _: true;
            merge = _loc: defs: builtins.foldl' lib.recursiveUpdate { } (map (d: d.value) defs);
          };
          default = { };
        };
        config._module.args.nixtants = config.nixtants;
      };
    in
    {
      nixosModules.default = mkNixtants;
      nixosModules.nixtants = mkNixtants;
      homeModules.default = mkNixtants;
      homeModules.nixtants = mkNixtants;
      darwinModules.default = mkNixtants;
    };
}
