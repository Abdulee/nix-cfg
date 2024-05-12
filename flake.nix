{
   description = "Nixos config flake";

   inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
         url = "github:nix-community/home-manager";
         inputs.nixpkgs.follows = "nixpkgs";
      };

      lanzaboote.url = "github:nix-community/lanzaboote";

      nixvim = {
         url = "github:nix-community/nixvim";
         inputs.nixpkgs.follows = "nixpkgs";
      };
   };

   outputs = { self, nixpkgs, lanzaboote, home-manager, nixvim, ... }@inputs:
      let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

   homeManagerModules = [
      nixvim.homeManagerModules.nixvim
   ];
   in
   {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
         specialArgs = {inherit inputs;};
         modules = [ 
            ./hosts/default/configuration.nix
            inputs.home-manager.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
         ];
      };

   };
}
