{
  description = "Personal Iosevka build plans";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    iosevka-upstream = {
      url = "github:be5invis/Iosevka";
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
      base = pkgsForEach.${system}.callPackage ./nix/ioshelfka-base.nix {inherit inputs self;};
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
    });

    devShells = forEachSystem (system: {
      default = pkgsForEach.${system}.mkShell {
        packages = [
          (pkgsForEach.${system}.python3.withPackages (python-pkgs:
            with python-pkgs; [
              pillow
              matplotlib
            ]))
        ];
      };
    });
  };
}
