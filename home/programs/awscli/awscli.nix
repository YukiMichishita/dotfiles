{
  pkgs,
  lib,
  config,
  dotfiles-private,
  ...
}: let
in {
  programs.awscli = {
    enable = true;
    settings = lib.mkMerge [
      # {
      #   "default" = {
      #     region = "ap-northeast-1";
      #     output = "json";
      #   };
      # }
      dotfiles-private.aws.privateProfiles.personal
    ];
  };
}
