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

      # ペイン分割のキーバインド
      bind | split-window -h
      bind - split-window -v

      # ペイン移動のキーバインド (Vim風)
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
