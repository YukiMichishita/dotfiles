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
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    xremap = {
      url = "github:xremap/nix-flake";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    dotfiles-private,
    plasma-manager,
    nixos-hardware,
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
        inherit inputs;
      };
      modules = [
        ./hosts/yuki.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bkup";
          home-manager.extraSpecialArgs = {
            inherit dotfiles-private;
          };
          home-manager.sharedModules = [
            plasma-manager.homeModules.plasma-manager
          ];
        }
      ];
    };

    devShells.x86_64-linux.default = with import nixpkgs {system = "x86_64-linux";};
      mkShell {
        packages = [
          gh
          nixos-rebuild
          git
          (writeShellApplication {
            name = "rebuild";
            runtimeInputs = [gh nixos-rebuild];
            text = ''
              sudo env "NIX_CONFIG=access-tokens = github.com=$(gh auth token)"   nixos-rebuild switch --flake .#yuki
            '';
          })
        ];
      };
  };
}
