{
  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/6909e461de4ecafbfac42e7a7a9e53da01ebf244";

    # nixpkgs-old.url =
    # NOTE: Last commit before EOL nodejs 16 dropped.
    # "github:NixOS/nixpkgs/2912f7ec10bcfd7082e0d4094f6c882237c511e4";

    # "github:NixOS/nixpkgs/nixos-23.05";
    # NOTE https://github.com/NixOS/nixpkgs/issues/261820#issuecomment-1775502830
    # NOTE: See https://github.com/NixOS/nixpkgs/pull/262124
    nixpkgs-pr-262124.url = "github:NixOS/nixpkgs/refs/pull/262124/head";
  };

  outputs = { self, nixpkgs, nixpkgs-pr-262124 }: {
    packages = builtins.mapAttrs (system: _:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.permittedInsecurePackages = [ "nodejs-slim-16.20.2" ];
          overlays = [
            (final: _: {
              nodejs = final.callPackage
                "${nixpkgs-pr-262124}/pkgs/development/web/nodejs/v16.nix" {
                  enableNpm = false;
                };
            })
          ];
        };
      in { default = pkgs.nodejs; }) nixpkgs.legacyPackages;
  };
}
