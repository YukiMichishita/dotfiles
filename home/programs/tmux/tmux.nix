{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;

    # Prefix key (デフォルトはCtrl-b)
    prefix = "C-b";

    # 基本設定
    extraConfig = ''
      # ウィンドウ番号を1から始める
      set -g base-index 1
      setw -g pane-base-index 1

      # ウィンドウ番号を自動で振り直す
      set -g renumber-windows on

      # ステータスバーの更新間隔
      set -g status-interval 1

      # ペイン分割のキーバインド（現在のディレクトリを引き継ぐ）
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # 新しいウィンドウも現在のディレクトリを引き継ぐ
      bind c new-window -c "#{pane_current_path}"

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

      # プレフィックスキー + h/j/k/lでペイン移動（従来通り）
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

      # ステータスバーのカラー設定
      set -g status-style bg=black,fg=white
      set -g status-left "[#S] "
      set -g status-right "%Y-%m-%d %H:%M:%S"
    '';
  };
}
