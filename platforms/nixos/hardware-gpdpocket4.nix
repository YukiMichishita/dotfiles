# Hardware configuration for GPD Pocket 4
{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports =
    []
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      gpd-pocket-4
    ]);

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c9dc8cf6-ce24-40fe-b479-42f52228f9a0";
    fsType = "ext4";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  # Enables DHCP on each ethernet and wireless interface.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
