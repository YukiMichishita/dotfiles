{
  pkgs,
  dotfiles-private,
  ...
}: {
  imports = [
    ../platforms/nixos/nixos-common.nix
  ];
  home-manager.users."yukimichishita" = import ../home/dws.nix;
}
