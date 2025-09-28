{
  inputs,
  pkgs,
  dotfiles-private,
  ...
}: {
  imports = [
    ../platforms/nixos-common.nix
    ../platforms/hardware-gpdpocket4.nix
  ];

  # ホスト名設定
  networking.hostName = "nixos";

  # Home Manager設定
  home-manager.users."yukimichishita" = import ../home/yukimichishita.nix;
}
