{
  config,
  lib,
  pkgs,
  dotfiles-private,
  ...
}: {
  imports = [
    ./programs/nvim/neovim.nix
    ./programs/awscli/awscli.nix
    ./programs/wezterm/wezterm.nix
    ./programs/python/python.nix
    ./programs/git/git.nix
    ./programs/zsh.nix
    ./programs/ssh.nix
  ];
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gcc
    lldb
    libcxx
    cmake
    terraform
    nerd-fonts.jetbrains-mono
    alejandra

    go
    gotools
    gopls
    gofumpt
    delve
    nodejs_24
    nodePackages.prettier
    stylua
    ffmpeg
    lean4
    claude-code
    ripgrep
    glow
    gitFull
  ];

  # 共通環境変数
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # フォント設定
  fonts.fontconfig.enable = true;
}
