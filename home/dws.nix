{
  pkgs,
  lib,
  dotfiles-private,
  ...
}: {
  imports = [./common.nix];

  home.username = "mitchy";
  home.homeDirectory = lib.mkForce "/Users/mitchy";
  home.packages = with pkgs; [
    openconnect
  ];

  programs.git = {
    userEmail = "yuki.michishita@mmmcorp.co.jp";
    extraConfig = {
      secrets = {
        providers = "git secrets --aws-provider";
        patterns = [
          ''(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}''
          ''("|')?(AWS|aws|Aws)?_?(SECRET|secret|Secret)?_?(ACCESS|access|Access)?_?(KEY|key|Key)("|')?\s*(:|=>|=)\s*("|')?[A-Za-z0-9/+=]{40}("|')?''
          ''("|')?(AWS|aws|Aws)?_?(ACCOUNT|account|Account)_?(ID|id|Id)?("|')?\s*(:|=>|=)\s*("|')?[0-9]{4}-?[0-9]{4}-?[0-9]{4}("|')?''
        ];
        allowed = dotfiles-private.git.config.extraConfig.secrets.allowed.dws;
      };
    };
  };

  programs.awscli = {
    enable = true;
    settings = lib.mkMerge [
      # {
      #   "default" = {
      #     region = "ap-northeast-1";
      #     output = "json";
      #   };
      # }
      dotfiles-private.aws.privateProfiles.dws
      dotfiles-private.aws.privateProfiles.pxdt
    ];
  };

  programs.ssh = {
    extraConfig = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };

  targets.darwin.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
  };
  targets.darwin.linkApps.enable = true;

  home.file.".config/kanata/kanata.kbd".text = ''
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
      _  q w e r t y u i o p _
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
      lmet
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
}
