{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
    ];
    commandLineArgs = [
    ];
  };
}
