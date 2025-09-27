{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-private = {
      url = "github:YukiMichishita/dotfiles-private?ref=main";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    dotfiles-private,
    ...
  }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#YukiMichishitanoMacBook-Air
    darwinConfigurations."YukiMichishitanoMacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        primaryUserName = "mitchy";
        inherit dotfiles-private;
      };
      modules = [
        ./hosts/dws.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            primaryUserName = "mitchy";
            inherit dotfiles-private;
          };
        }
      ];
    };

    nixosConfigurations."yuki" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit dotfiles-private;
      };
      modules = [
        ./hosts/yuki.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit dotfiles-private;
          };
        }
      ];
    };
  };
}
