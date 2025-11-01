{
  inputs,
  pkgs,
  dotfiles-private,
  ...
}: {
  imports = [
    ../platforms/nixos/nixos-common.nix
    ../platforms/nixos/nixos-common.nix
    ../platforms/nixos/hardware-gpdpocket4.nix
  ];

  # ホスト名設定
  networking.hostName = "nixos";
  # ユーザー設定
  users.users.yukimichishita = {
    isNormalUser = true;
    description = "Yuki Michishita";
    extraGroups = ["networkmanager" "wheel" "input" "docker"];
    shell = pkgs.zsh;
  };

  # Home Manager設定
  home-manager.users."yukimichishita" = import ../home/yukimichishita.nix;
}
