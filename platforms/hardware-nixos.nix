# Common NixOS hardware configuration
{ config, lib, pkgs, ... }:

{
  # ハードウェア関連サービス
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  
  # Bluetooth設定
  hardware.bluetooth.enable = true;
}