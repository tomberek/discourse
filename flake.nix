{
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  outputs = { self, nixpkgs, dream2nix }@inputs:
    let
      source = builtins.filterSource (path: type: type != "directory" || baseNameOf path != "packages") ./.;
      dream2nix = inputs.dream2nix.lib.init {
        # modify according to your supported systems
        systems = [ "x86_64-linux" ];
        config.projectRoot = source;
      };
    in dream2nix.makeFlakeOutputs {
      inherit source;
      packageOverrides = {
              discourse = {
                yarn = {
                  preBuild = ''
~                   alias yarn=${nixpkgs.legacyPackages.x86_64-linux.yarn.outPath}/bin/yarn
                    '';
                };
              };
          };
    };
}
