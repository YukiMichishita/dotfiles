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
  targets.darwin.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };
  targets.darwin.linkApps.enable = true;
}
