{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Yuki Michishita";
    lfs.enable = true;

    ignores = [
      ".DS_Store"
      "**/.idea/"
      "venv*"
      ".cursor"
      ".claude"
      ".memo"
      "compile_commands.json"
      ".clangd"
      ".cache"
      "CMakeCache.txt"
      "pyrightconfig.json"
    ];
    extraConfig = {
      url."git@gitlab.com:".insteadOf = "https://gitlab.com/";
      core.editor = "vim";
      pull.rebase = false;
      merge.tool = "nvimdiff";
      mergetool.keepBackup = false;
      pager.log = false;
      pager.diff = false;
      pager.show = false;
    };
  };
}
