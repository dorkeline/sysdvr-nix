{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux"];
    foreachSupported = inputs.nixpkgs.lib.genAttrs supportedSystems;
  in {
    overlays.default = _: prev:
      import ./pkgs {
        inherit inputs;
        pkgs = prev;
      };

    packages = foreachSupported (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
        self.overlays.default null (import nixpkgs {
          inherit system;
        })
        // {
          default = self.packages.${system}.SysDVR-Client;
        }
    );

    nixosModules.default = import ./modules/sysdvr.nix self;

    formatter = foreachSupported (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
