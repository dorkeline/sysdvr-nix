# SysDVR-nix

Package and module for SysDVR

# Usage

You can run this as a one-off using `nix run github:dorkeline/SysDVR-nix`. Passing args to SysDVR can be done like this `nix run github:dorkeline/SysDVR-nix -- bridge 192.168.0.198 --rtsp`

# Installation

If you manage your system with flakes you can add `github:dorkeline/SysDVR-nix` as an input. Then in your configuration.nix (or any file included by it) it should be as simple as

```nix
{ inputs, ... }: 
{
    imports = [inputs.SysDVR-nix.nixosModules.default];

    hardware.sysdvr.enable = true;
}
```

By default this will also setup udev rules so it can access the switch over usb, you may need to `sudo udevadm trigger` + plug out and plug in the switch, logout or reboot for those to take effect - in decreasing order of "it doesnt work what do i try next".

# Credits
- [exelix11](https://github.com/exelix11/SysDVR) for SysDVR which is epic
- [fufexan's nix-gaming](https://github.com/fufexan/nix-gaming) i took as base for how to structure this flake
