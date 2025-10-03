{
  pkgs,
  lib,
  dotfiles-private,
  ...
}: let
  hsInit = ''
    local targets = { "Logitech", "Keychron", "HHKB" } -- 製品名の一部でOK
    local function sh(cmd, args)
      hs.task.new(cmd, nil, args):start()
    end
    hs.usb.watcher.new(function(e)
      if e.eventType == "added" then
        for _,pat in ipairs(targets) do
          if (e.productName or ""):match(pat) then
            -- Karabiner を軽くリロード（プロファイル再選択）
            sh("/Library/Karabiner-Elements/bin/karabiner_cli", {"--select-profile","Default"})
            -- Kanata(LaunchAgent)を掴み直す
            sh("/bin/launchctl", {"kickstart","-k","gui/"..hs.host.uid().."/dev.yuki.kanata"})
            break
          end
        end
      end
    end):start()
  '';
in {
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

  home.file.".hammerspoon/init.lua".text = hsInit;

  home.file.".config/kanata/kanata.kbd".text = let
    sharedKeymap = import ../shared/kanata-keymap.nix;
  in sharedKeymap.kanataKeymap;
}
