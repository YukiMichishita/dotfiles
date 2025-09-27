{
  pkgs,
  dotfiles-private,
  ...
}: {
  imports = [
    ../platforms/nixos-common.nix
  ];
  home-manager.users."yukimichishita" = import ../home/dws.nix;
}
