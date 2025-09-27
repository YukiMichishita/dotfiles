{
  pkgs,
  lib,
  ...
}: {
  programs.clang-tools = {
    enable = true;
  };
}
