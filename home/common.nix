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
    ./programs/tmux/tmux.nix
  ];
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  programs.codex.enable = true;

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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

    # Rust development tools (using fenix)
    (fenix.packages.${pkgs.system}.combine [
      fenix.packages.${pkgs.system}.stable.cargo
      fenix.packages.${pkgs.system}.stable.clippy
      fenix.packages.${pkgs.system}.stable.rust-src
      fenix.packages.${pkgs.system}.stable.rustc
      fenix.packages.${pkgs.system}.stable.rustfmt
      fenix.packages.${pkgs.system}.stable.rust-analyzer
      fenix.packages.${pkgs.system}.targets.x86_64-unknown-uefi.stable.rust-std
    ])

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
