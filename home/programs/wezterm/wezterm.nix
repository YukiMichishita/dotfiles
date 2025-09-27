{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.wezterm = {
    enable = true;
  };

  home.packages = with pkgs; [
    wezterm.terminfo
  ];

  xdg.configFile."wezterm/wezterm.lua".source =
    ./wezterm.lua;

  # wezterm の terminfo をホーム配下にインストール
  home.activation.installWeztermTerminfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
    tmp=$(mktemp)
    ${pkgs.curl}/bin/curl -fsSL -o "$tmp" \
      https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo
    ${pkgs.ncurses}/bin/tic -x -o "$HOME/.terminfo" "$tmp"
    rm -f "$tmp"
  '';

  # 見つからない問題を避けるために DIRS を通しておく（任意）
  home.sessionVariables.TERMINFO_DIRS = "$HOME/.terminfo:${pkgs.ncurses}/share/terminfo";
}
