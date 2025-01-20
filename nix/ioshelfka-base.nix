{
  inputs,
  self,
  lib,
  # Deps
  buildNpmPackage,
  importNpmLock,
  remarshal,
  ttfautohint-nox,
  nerd-font-patcher,
  # Options
  variant ? null, # "Mono" or "Term"
  features ? "ttf", # "full", "ttf" or "ttf-unhinted"
  nerdfont ? false,
  ...
}: let
  inherit (lib.strings) concatStringsSep match optionalString;

  # Derived package attributes.
  pname = "Ioshelfka${variant}";
  src = inputs.iosevka-upstream;
  version = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" src.lastModifiedDate);

  # Choose build targets according to the features argument. This can be
  # used to dynamically generate Ioshelfka variants by overriding the base
  # derivation.
  targets =
    if (features == "full")
    then "contents::${pname}"
    else if (features == "ttf")
    then "ttf::${pname}"
    else if (features == "ttf-unhinted")
    then "ttf-unhinted::${pname}"
    else throw "Unsupported features: ${toString features}";

  buildPlan = self + /plans/${lib.toLower variant}.toml;
in
  buildNpmPackage {
    inherit pname version;
    inherit src;

    npmDeps = importNpmLock {
      npmRoot = src.outPath;
    };

    npmConfigHook = importNpmLock.npmConfigHook;

    nativeBuildInputs = [
      remarshal
      ttfautohint-nox
      nerd-font-patcher
    ];

    postPatch = ''
      cp -avr ${buildPlan} private-build-plans.toml
    '';

    enableParallelBuilding = true;
    buildPhase = ''
      export HOME=$TMPDIR
      runHook preBuild

      # Build everything: TTF + webfont, hinted + unhinted
      npm run build --no-update-notifier --targets ${targets} \
        -- --jCmd=$NIX_BUILD_CORES

      runHook postBuild
    '';

    postBuild = optionalString nerdfont ''
      fontdir="${placeholder "out"}/share/fonts/truetype/NerdFonts"
      mkdir -p "$fontdir"
      for ttf_file in dist/${pname}/TTF/*.ttf; do
          ${lib.getExe nerd-font-patcher} "$ttf_file" --complete --no-progressbars \
                --outputdir "$fontdir"/NerdFonts/${pname}
      done
    '';

    installPhase = ''
      runHook preInstall

      fontdir="${placeholder "out"}/share/fonts/truetype"
      mkdir -p "$fontdir"
      install -Dm644 "dist/$pname/TTF"/* "$fontdir"

      runHook postInstall
    '';

    meta = {
      homepage = "https://typeof.net/Iosevka/";
      description = "Versatile typeface for code, from code";
      license = lib.licenses.ofl;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [NotAShelf];
    };
  }
