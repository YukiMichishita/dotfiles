{
  pkgs,
  primaryUserName,
  dotfiles-private,
  ...
}: {
  imports = [
    ../platforms/darwin/darwin-common.nix
  ];

  system.primaryUser = primaryUserName;
  users.users.mitchy.home = "/User/${primaryUserName}";

  home-manager.users."mitchy" = import ../home/dws.nix;
  system.stateVersion = 6;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };
    casks = [
      "apidog"
      "showyedge"
    ];
  };
}
