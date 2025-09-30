{
  pkgs,
  primaryUserName,
  config,
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
    brews = [
      "kanata"
    ];
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
      "karabiner-elements"
    ];
  };

  # https://github.com/jtroo/kanata/discussions/1537
  #### 1) DriverKit の "activate" を毎回実行（ユーザ許可後は idempotent）
  launchd.daemons.karabiner-vhidmanager = {
    serviceConfig = {
      Label = "dev.mitchy.karabiner-vhidmanager";
      ProgramArguments = [
        "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
        "activate"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/karabiner-vhidmanager.out.log";
      StandardErrorPath = "/var/log/karabiner-vhidmanager.err.log";
    };
  };

  #### 2) Karabiner の DriverKit ブリッジ・デーモン
  launchd.daemons.karabiner-vhiddaemon = {
    serviceConfig = {
      Label = "dev.mitchy.karabiner-vhiddaemon";
      ProgramArguments = [
        "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/karabiner-vhiddaemon.out.log";
      StandardErrorPath = "/var/log/karabiner-vhiddaemon.err.log";
    };
  };

  #### 3) kanata を root の LaunchDaemon で常駐（sudo 相当）
  launchd.daemons.kanata = {
    serviceConfig = {
      Label = "dev.mitchy.kanata";
      ProgramArguments = [
        "/opt/homebrew/bin/kanata"
        "-c"
        "/Users/mitchy/.config/kanata/kanata.kbd"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/kanata.out.log";
      StandardErrorPath = "/var/log/kanata.err.log";
    };
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
