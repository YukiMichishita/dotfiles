{
  config,
  lib,
  pkgs,
  dotfiles-private,
  fenix,
  ...
}: let
  rust-toolchain = fenix.packages.${pkgs.system}.fromToolchainFile {
    file = ./rust-toolchain.toml;
    sha256 = "sha256-SJwZ8g0zF2WrKDVmHrVG3pD2RGoQeo24MEXnNx5FyuI=";
  };
in {
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
    rust-toolchain

    # Haskell development tools
    ghc
    cabal-install
    stack
    haskell-language-server
    haskellPackages.hoogle
    haskellPackages.hlint
    haskellPackages.fourmolu

    # F# development tools
    dotnet-sdk_9
    fsautocomplete
    fantomas
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
