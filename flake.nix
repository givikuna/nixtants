{
  description = "nixtants - a global free-form namespace";

  outputs = { self }: {
    nixosModules.default = { lib, config, ... }: {
      options.nixtants = lib.mkOption {
        type = lib.types.mkOptionType {
          name = "nixtants";
          check = _: true;
          merge = _loc: defs: builtins.foldl' lib.recursiveUpdate { } (map (d: d.value) defs);
        };
        default = { };
      };
      config._module.args.nixtants = config.nixtants;
    };
    homeModules.default = self.nixosModules.default;
  };
}
