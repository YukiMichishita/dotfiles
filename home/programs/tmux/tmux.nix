{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;

    # 基本設定
    extraConfig = ''
      # ウィンドウ番号を1から始める
      set -g base-index 1
      setw -g pane-base-index 1

      set -sg escape-time 10
      set -g default-terminal "tmux-256color"

      # プレフィックス + r で .tmux.confを再読込
      bind-key r source-file ~/.config/tmux/tmux.conf \; \
      display-message "source-file done"

      # ウィンドウ番号を自動で振り直す
      set -g renumber-windows on

      # ステータスバーの更新間隔
      set -g status-interval 1

      # ペイン分割時のみ現在のディレクトリを引き継ぐ
      bind c new-window
      bind '"' split-window -v -c '#{pane_current_path}'
      bind % split-window -h -c '#{pane_current_path}'

      set -g pane-border-style 'fg=colour240'
      set -g pane-active-border-style 'fg=colour245'

      # vim-tmux-navigator: VimとTmuxのシームレスな移動
      # Ctrl-h/j/k/lでVimウィンドウとTmuxペインを横断
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R

      # プレフィックスキー + h/j/k/lでペイン移動
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # ペインのリサイズ
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # コピーモードでVim風のキーバインド
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # ウィンドウ名を自動で更新（ディレクトリ名 + gitブランチ）
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # ペイン選択時にディレクトリ名とgitブランチ名を表示
      set-hook -g after-select-pane 'run-shell "cd #{pane_current_path} && branch=\$(git branch --show-current 2>/dev/null || echo \"\") && dir=\$(basename \$(pwd)) && if [ -n \"\$branch\" ]; then tmux rename-window \"\$dir [\$branch]\"; else tmux rename-window \"\$dir\"; fi"'
      set-hook -g pane-focus-in 'run-shell "cd #{pane_current_path} && branch=\$(git branch --show-current 2>/dev/null || echo \"\") && dir=\$(basename \$(pwd)) && if [ -n \"\$branch\" ]; then tmux rename-window \"\$dir [\$branch]\"; else tmux rename-window \"\$dir\"; fi"'

      # ステータスバーのカラー設定
      set -g status-style bg=black,fg=white
      set -g status-left "[#S] "
      set -g status-right "%Y-%m-%d %H:%M:%S"

      # ウィンドウリストの設定
      set -g window-status-style fg=colour245,bg=black
      set -g window-status-current-style fg=yellow,bold,bg=black
      set -g window-status-separator " | "
    '';
  };
}
