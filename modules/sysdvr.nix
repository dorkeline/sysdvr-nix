self: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hardware.sysdvr;
  inherit (lib) mkIf mkEnableOption mkOption types optionalString;
in {
  options.hardware.sysdvr = {
    enable = mkEnableOption "Whether to enable the SysDVR module";

    addUdevRules = mkOption {
      default = true;
      type = types.bool;
      description = "Whether to add a udev rule for usb streaming access";
    };

    package = mkOption {
      default = self.packages.${pkgs.system}.SysDVR-Client;
      type = types.package;
      description = "The SysDVR package to use";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    services.udev.extraRules = optionalString (cfg.addUdevRules) ''
      # Nintendo Switch for SysDVR
      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3006", MODE="0666"
    '';
  };
}
