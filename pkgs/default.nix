{
  pkgs,
  inputs,
}: rec {
  CimguiSDL2Cross = pkgs.callPackage ./SysDVR-Client/CimguiSDL2Cross.nix {};
  SysDVR-Client = pkgs.callPackage ./SysDVR-Client {inherit CimguiSDL2Cross;};
}
