{
  description = "Personal Iosevka build plans";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    iosevka-upstream = {
      url = "github:be5invis/Iosevka?ref=refs/tags/v34.3.0";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in {
    packages = forEachSystem (system: let
      pkgs = pkgsForEach.${system};
      base = pkgs.callPackage ./nix/ioshelfka-base.nix {inherit inputs self;};
    in {
      ioshelfka-mono = base.override {
        variant = "Mono";
        features = "ttf";
      };

      ioshelfka-term = base.override {
        variant = "Term";
        features = "ttf";
      };

      ioshelfka-mono-nerd = base.override {
        variant = "Mono";
        features = "ttf";
        nerdfont = true;
      };

      ioshelfka-term-nerd = base.override {
        variant = "Term";
        features = "ttf";
        nerdfont = true;
      };

      ioshelfka-full = pkgs.linkFarmFromDrvs "ioshelfka-full" (with self.packages.${system}; [
        ioshelfka-mono
        ioshelfka-term
        ioshelfka-mono-nerda
        ioshelfka-term-nerd
      ]);
    });

    devShells = forEachSystem (system: let
      pkgs = pkgsForEach.${system};
    in {
      default = pkgs.mkShell {
        packages = [
          # For generating font previews
          (pkgs.python3.withPackages (python-pkgs:
            with python-pkgs; [
              pillow
              matplotlib
            ]))
        ];
      };
    });

    hydraJobs = self.packages;
  };
}
