{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-nixos.nix
  ];
  # ブートローダー設定
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ネットワーク設定
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # 国際化設定
  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # タイムゾーン設定
  time.timeZone = "Asia/Tokyo";

  # オーディオ設定
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # プリンター設定
  services.printing.enable = true;

  # X11とWayland設定
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Display Manager
  services.displayManager.sddm.enable = true;

  # Desktop Manager
  services.desktopManager.plasma6.enable = true;

  # システムパッケージ
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git

    # アイコンテーマとカーソル
    kdePackages.breeze-icons
    kdePackages.oxygen-icons
    hicolor-icon-theme
    adwaita-icon-theme
    libsForQt5.breeze-icons

    # システムユーティリティ
    kdePackages.baloo
    kdePackages.polkit-kde-agent-1

    # ハードウェア関連
    upower
    udisks2
    power-profiles-daemon

    # マルチメディア
    ffmpeg

    # ネットワークツール
    networkmanager
    modemmanager
    bluez
    bluez-tools

    # その他重要なパッケージ
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    xdg-desktop-portal-gtk

    # X11/Wayland関連
    wayland-utils
    wl-clipboard
  ];

  # ユーザー設定
  users.users.yukimichishita = {
    isNormalUser = true;
    description = "Yuki Michishita";
    extraGroups = ["networkmanager" "wheel"];
  };

  # その他のサービス
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.dbus.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  security.polkit.enable = true;

  # XDG Portal設定
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
  };

  # Nix設定
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Unfreeパッケージを許可
  nixpkgs.config.allowUnfree = true;

  # kanata keyboard configuration
  services.kanata = {
    enable = true;
    package = pkgs.kanata-with-cmd;

    keyboards = {
      "corne" = {
        devices = [
          "/dev/input/by-id/usb-DH747_W-CORNE_vial:f64c2b3c-event-kbd"
        ];
        extraDefCfg = ''
          process-unmapped-keys yes
          danger-enable-cmd yes
        '';
        config = ''
          (defsrc
            tab  q w e r t y u i o p bspc
            lctl a s d f g h j k l ; '
            lsft z x c v b n m , . / esc
               lmet caps spc ret del rmet
          )

          (defalias
              JP_ON_CMD  C-spc
              EN_CMD     C-spc
          )

          (deflayer base
            tab  q w e r t y u i o p bspc
            _
              (tap-hold-release 200 250 a lalt)
              (tap-hold-release 200 250 s lmet)
              (tap-hold-release 200 250 d lctl)
              (tap-hold-release 200 250 f lsft)
              g h
              (tap-hold-release 200 250 j lsft)
              (tap-hold-release 200 250 k lctl)
              (tap-hold-release 200 250 l lmet)
              (tap-hold-release 200 250 ; lalt)
            '
            _ z x c v b n m , . / _
            C-spc
            (tap-hold 200 200 spc (layer-toggle raise))
            (tap-hold 200 200 spc (layer-toggle util))
            rsft
            (tap-hold 200 200 ret (layer-toggle lower))
            bspc
          )

          (deflayer lower
            _ f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11
            _ _ _ _ _ _ _ _ _ _ f12 _
            _ _ _ _ _ _ _ _ _ _ _ _
                _ esc _ _ _ _
          )

          (deflayer raise
            _ 1 2 3 4 5   6    7    8  9   0 _
            _ _ _ _ _ tab left down up right - =
            _ _ _ _ _ _ _ _ [ ] bksl `
                _ _ _ _ _ _
          )

          (deflayer util
            _ 1 2 3 4 5   6    7    8  9     0 _
            _ M-a _ _ _ _ home down up end _ _
            _ M-z M-x M-c M-v _ _ _ pgup pgdn _ _
                _ _ _ _ _ _
          )
        '';
      };

      "internalKeyboard" = {
        devices = [
          "/dev/input/by-path/pci-0000:c4:00.3-usb-0:1:1.0-event-kbd"
          "/dev/input/by-path/pci-0000:c4:00.3-usbv2-0:1:1.0-event-kbd"
          "/dev/input/by-id/bluetooth-hhkb-hybrid-1-event-kbd"
        ];
        extraDefCfg = ''
          process-unmapped-keys yes
          danger-enable-cmd yes
        '';
        config = ''
          (defsrc
            esc 1 2 3 4 5 6 7 8 9 0 - = del
            tab q w e r t y u i o p [ ] bspc
            lctl a s d f g h j k l ; ' ret
            lsft z x c v b n m , . / rsft
              lalt lmet   spc    rmet ralt rctl
          )
          (defalias
              JP_ON_CMD  C-spc
              EN_CMD     C-spc
          )

          (deflayer base
            esc 1 2 3 4 5 6 7 8 9 0 - = del
            tab q w e r t y u i o p [ ] bspc
            lctl a s d f g h j k l ; ' ret
            lsft
              (tap-hold-release 200 170 z lalt)
              (tap-hold-release 200 170 x lmet)
              (tap-hold-release 200 170 c lctl)
              (tap-hold-release 200 170 v lsft)
              b  n
              (tap-hold-release 200 170 m lsft)
              (tap-hold-release 200 170 , lctl)
              (tap-hold-release 200 170 . lmet)
              (tap-hold-release 200 170 / lalt)
            rsft
            lalt lmet   spc    rmet ralt rctl
          )

          (deflayer primary
            esc 1 2 3 4 5 6 7 8 9 0 - = del
            tab q w e r t y u i o p [ ] bspc
            lctl a s d f g h j k l ; ' ret
            lsft z x c v b n m , . / rsft
              lalt lmet   spc    rmet ralt rctl
          )
        '';
      };
    };
  };

  # 入力メソッド設定 (fcitx5)
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  system.stateVersion = "24.05";
}
