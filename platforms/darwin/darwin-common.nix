{
  pkgs,
  primaryUserName,
  ...
}: {
  # システムにインストールするパッケージ
  environment.systemPackages = with pkgs; [
    vim
    git
    scroll-reverser
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.package = pkgs.nix;

  # 非自由パッケージを許可
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      "google-japanese-ime"
      "slack"
      "rectangle"
      "datagrip"
      "goland"
      "clion"
      "rustrover"
      "pycharm"
      "visual-studio-code"
      "maccy"
      "iterm2"
      "chatgpt"
      "docker"
      "discord"
    ];
  };

  # Finder設定
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXEnableExtensionChangeWarning = false;
    ShowPathbar = true;
    ShowStatusBar = true;
  };

  # Dock設定
  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    tilesize = 5;
    orientation = "left";
  };
}
