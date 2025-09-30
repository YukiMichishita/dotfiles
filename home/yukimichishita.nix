{
  pkgs,
  lib,
  dotfiles-private,
  ...
}: let
  headUpDaisy = pkgs.runCommand "headup-daisy-font" {} ''
    install -Dm444 ${pkgs.fetchurl {
      url = "https://hicchicc.github.io/00ff/x14y24pxHeadUpDaisy.ttf";
      sha256 = "sha256-wLjH7pNnpD2BhKZWKai9hn9oZxr3JnilNQ8urtbhA7M=";
    }} $out/share/fonts/truetype/x14y24pxHeadUpDaisy.ttf
  '';
in {
  imports = [
    ./common.nix
  ];

  home.username = "yukimichishita";
  home.homeDirectory = "/home/yukimichishita";

  home.packages = with pkgs; [
    google-chrome
    gh
    git-lfs
    headUpDaisy
  ];

  programs.git = {
    userEmail = "michishita.ocu@gmail.com";
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "ui.key.accelKey" = 224;
      };
    };
  };

  # XDG設定
  xdg.enable = true;

  fonts.fontconfig.enable = true;
  programs.plasma = {
    fonts = {
      general.family = "x14y24pxHeadUpDaisy";
      general.pointSize = 12;
      fixedWidth.family = "x14y24pxHeadUpDaisy";
      fixedWidth.pointSize = 12;
      small.family = "x14y24pxHeadUpDaisy";
      toolbar.family = "x14y24pxHeadUpDaisy";
      menu.family = "x14y24pxHeadUpDaisy";
    };
  };
}
