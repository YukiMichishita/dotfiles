{
  config,
  lib,
  pkgs,
  dotfiles-private,
  fenix,
  ...
}: {
  imports = [
    ./programs/nvim/neovim.nix
    ./programs/awscli/awscli.nix
    ./programs/wezterm/wezterm.nix
    ./programs/python/python.nix
    ./programs/chromium/chromium.nix
    ./programs/git/git.nix
    ./programs/zsh.nix
  ];
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gcc
    gnumake
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

    # Rust development tools
    rustup
    nodejs_24
    nodePackages.prettier
    stylua
    ffmpeg
    lean4
    claude-code
    ripgrep
    glow
    gitFull
    qemu
  ];

  # 共通環境変数
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # フォント設定
  fonts.fontconfig.enable = true;
}
