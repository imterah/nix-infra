{
  description = "Tera's Home Infrastructure";

  inputs = {
    # Server-specific
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # Workstation-specific
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    wallpapers = {
      url = "git+https://git.terah.dev/imterah/wallpapers?shallow=1&ref=main";
      flake = false;
    };

    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";

    nix-secrets = {
      url = "git+https://git.terah.dev/imterah/sops?shallow=1&ref=main";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flake-utils,
    ...
  } @ inputs: let
    mkFlake = flake-utils.lib.mkFlake;
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib // home-manager.lib;

    systems = ["x86_64-linux"];
    system = "x86_64-linux";
  in
    mkFlake {
      inherit self inputs nixpkgs home-manager;
      overlays = import ./overlays.nix {inherit inputs;};

      hostDefaults.extraArgs = {inherit flake-utils;};
      hostDefaults.specialArgs = {
        inherit inputs;
        inherit (self) outputs;
      };

      formatter."x86_64-linux" = pkgs.alejandra;

      # `nix develop` support
      devShells = let
        forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
        lib = nixpkgs.lib // home-manager.lib;
        systems = [
          "x86_64-linux"
        ];
        pkgsFor = lib.genAttrs systems (system:
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          });
      in
        forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: super: {
          vencord = channels.nixpkgs-unstable.vencord;
        })
      ];

      # Servers
      ## Main Docker-based host
      hosts.andromeda = {
        system = "x86_64-linux";
        modules = [
          inputs.disko.nixosModules.default
          (import ./hosts/andromeda/disko.nix {device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";})
          inputs.impermanence.nixosModules.impermanence
          ./hosts/andromeda/configuration.nix
        ];
      };

      # Workstations
      ## Main Laptop
      hosts.supernova = {
        system = "x86_64-linux";
        modules = [
          inputs.disko.nixosModules.default
          ./hosts/supernova/configuration.nix
        ];
      };

      # Home Config
      homeConfigurations = {
        "tera@supernova" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          modules = [./home/personal.nix];
          extraSpecialArgs = {
            inherit inputs;
            inherit (self) outputs;
          };
        };
      };
    };
}
