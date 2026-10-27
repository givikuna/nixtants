{
  description = "nixtants - a global free-form namespace";

  outputs =
    { self }:
    let
      mkNixtants = name: { lib, config, ... }: {
        options.${name} = lib.mkOption {
          type = lib.types.mkOptionType {
            name = name;
            description = "free-form namespace";
            check = _: true;
            merge = _loc: defs: builtins.foldl' lib.recursiveUpdate { } (map (d: d.value) defs);
          };
          default = { };
        };
        config._module.args.${name} = config.${name};
      };
    in
    {
      lib.mkNixtants = mkNixtants;

      nixosModules.default = mkNixtants "nixtants";
      nixosModules.nixtants = mkNixtants "nixtants";

      homeModules.default = mkNixtants "nixtants";
      homeModules.nixtants = mkNixtants "nixtants";

      darwinModules.default = mkNixtants "nixtants";
      darwinModules.nixtants = mkNixtants "nixtants";
    };
}
