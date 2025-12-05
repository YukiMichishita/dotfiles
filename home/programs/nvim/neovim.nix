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
  vim-wintabs = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-wintabs";
    version = "2024-08-16";
    src = pkgs.fetchFromGitHub {
      owner = "zefei";
      repo = "vim-wintabs";
      rev = "6d18d62ae0f293a108afee8c514706027faefcf3";
      sha256 = "0n677r3snif7rq0z3l16ig9w9vb855ghf2p89n1l0z1s9y8619k0";
    };
  };
  vim-wintabs-powerline = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-wintabs-powerline";
    version = "2020-08-27";
    src = pkgs.fetchFromGitHub {
      owner = "zefei";
      repo = "vim-wintabs-powerline";
      rev = "c6713349aa965ed32c0f6927e7121c8e04b27163";
      sha256 = "02ylkigsz4v7gakyn8x2filgw6xir6jbnkfm6789a3mk1ilkd9f2";
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
  swagger-preview-nvim = pkgs.buildNpmPackage {
    pname = "swagger-preview-nvim";
    version = "2024-12-04";
    src = pkgs.fetchFromGitHub {
      owner = "vinnymeller";
      repo = "swagger-preview.nvim";
      rev = "42999dd6ad0bbb3e6ca5e857f3fc3c12de014110";
      sha256 = "sha256-0PmasvfQKBKtqYOoY/CCqVMuku2zSeex3qGK8KVqPE0=";
    };
    npmDepsHash = "sha256-y0GmMTbpfxkVrc7OGj+wUWOjtITMBDmgMlfMZ4DagVc=";
    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      neo-tree-nvim
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
      copilot-lua
      lean-nvim
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
      # vim-bufsurf # vim-wintabsと競合するため無効化
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
      nvim-treesitter-textobjects
      sidekick-nvim
      vim-wintabs
      vim-wintabs-powerline
      vim-tmux-navigator
      ssr
      swagger-preview-nvim
      render-markdown-nvim
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
      pkgs.nodePackages.typescript-language-server # TypeScript/JavaScript LSP
      dbee-backend
      pkgs.ctags
      pkgs.nodejs
    ];
  };

  xdg.configFile."nvim/init.lua".source =
    ./nvim-init.lua;

  xdg.configFile."nvim/lua".source =
    ./lua;

  xdg.configFile.".vimrc".source =
    ./.vimrc;
}
