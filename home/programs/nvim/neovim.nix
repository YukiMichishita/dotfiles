{
  pkgs,
  lib,
  ...
}: let
  vim-bufsurf = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-bufsurf";
    version = "2025-09-01";
    src = pkgs.fetchFromGitHub {
      owner = "ton";
      repo = "vim-bufsurf";
      rev = "e6dbc7ad66c7e436e5eb20d304464e378bd7f28c";
      sha256 = "o/Uf4bnh3IctKnT50JitTe5/+BUrCyrlOOzkmwAzxLk=";
    };
  };
  nvim-dbee = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-dbee";
    version = "0.1.9";
    src = pkgs.fetchFromGitHub {
      owner = "kndndrj";
      repo = "nvim-dbee";
      rev = "v0.1.9";
      sha256 = "AOime4vG0NFcUvsd9Iw5SxR7WaeCsoCRU6h5+vSkt4M=";
    };
    doCheck = false;
  };
  dbee-backend = pkgs.buildGoModule {
    pname = "dbee";
    version = "0.1.9";
    src = pkgs.fetchFromGitHub {
      owner = "kndndrj";
      repo = "nvim-dbee";
      rev = "v0.1.9";
      sha256 = "AOime4vG0NFcUvsd9Iw5SxR7WaeCsoCRU6h5+vSkt4M=";
    };
    modRoot = "./dbee";
    subPackages = ["."];
    vendorHash = "sha256-U/3WZJ/+Bm0ghjeNUILsnlZnjIwk3ySaX3Rd4L9Z62A=";
    buildInputs = [
      pkgs.arrow-cpp
      pkgs.duckdb
    ];
  };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      neo-tree-nvim
      nvim-web-devicons
      nvim-web-devicons
      diffview-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-live-grep-args-nvim
      conform-nvim
      (nvim-treesitter.withPlugins (p: [
        p.python
        p.go
        p.sql
        p.haskell
        p.fsharp
      ]))
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      mason-nvim
      lean-nvim
      completion-nvim
      vscode-nvim
      vim-fugitive
      nvim-cmp
      cmp-nvim-lsp
      nvim-lspconfig
      nvim-ufo
      nvim-spectre
      nvim-scrollbar
      gitsigns-nvim
      nvim-hlslens
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-dap-virtual-text
      claudecode-nvim
      snacks-nvim
      glow-nvim
      persisted-nvim
      plenary-nvim
      harpoon2
      vim-bufsurf
      vim-easymotion
      nvim-dbee
      vimade
      vim-mustache-handlebars
      vim-test
      nvim-nio
      neotest
      neotest-go
      neotest-python
      neotest-jest
      fzf-lua
      tagbar
      nvim-treesitter-context
    ];

    extraPackages = [
      pkgs.pyright
      pkgs.gopls
      pkgs.sqls
      pkgs.nil # Nix LSP
      pkgs.lua-language-server
      pkgs.jdt-language-server
      pkgs.haskell-language-server # Haskell LSP
      pkgs.fsautocomplete # F# LSP
      dbee-backend
      pkgs.ctags
    ];
  };

  xdg.configFile."nvim/init.lua".source =
    ./nvim-init.lua;

  xdg.configFile."nvim/lua".source =
    ./lua;

  xdg.configFile.".vimrc".source =
    ./.vimrc;
}
