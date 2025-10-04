{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true; # compinit は HM がやってくれる
    completionInit = "autoload -Uz compinit && compinit -C"; # -Cで高速化
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
    };

    # ここで"compinit の前"に実行したい処理を書く
    initContent = let
      zshConfigEarlyInit =
        lib.mkOrder
        550
        ''
          source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

          # oh-my-zshのcompinit実行をスキップ（高速化）
          skip_global_compinit=1
        '';

      zshConfig =
        # compinit 後＝通常の初期化（プロンプトや setopt など）
        ''
          # alias
          alias pip="python3 -m pip"
          alias k="clear"
          fpath=(~/.zsh $fpath)
          zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

          export GOPATH="$(${pkgs.go}/bin/go env GOPATH)"
          export PATH="$PATH:$GOPATH/bin:$GOPATH"

          # zsh オプション
          setopt interactivecomments
          setopt PROMPT_SUBST
          unsetopt nomatch

          # git-prompt 表示オプション
          export GIT_PS1_SHOWDIRTYSTATE=true
          export GIT_PS1_SHOWUNTRACKEDFILES=true
          export GIT_PS1_SHOWSTASHSTATE=true
          export GIT_PS1_SHOWUPSTREAM=auto

          # プロンプト（__git_ps1 利用）
          PS1='%F{blue} %* %f%F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f\$ '

          nix-pyshell() {
            if [[ $# -eq 0 ]]; then
              echo "Usage: pyenv-nix <pkg1> [pkg2 ...]"
              return 1
            fi
            local pkgs
            pkgs=$(printf " ps.%s" "$@")
            nix-shell -p "python3.withPackages (ps: [''${pkgs} ])"
          }
        '';
    in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
      ];
  };
  home.file.".zsh/_git" = {
    source = "${pkgs.git}/share/git/contrib/completion/git-completion.zsh";
  };
  home.file.".zsh/git-completion.bash" = {
    source = "${pkgs.git}/share/git/contrib/completion/git-completion.bash";
  };
}
