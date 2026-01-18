# Ioshelfka

[Iosevka]: https://typeof.net/Iosevka

Home-baked [Iosevka] builds with personal twists and a fancy posterior. Based on
the FiraCode template, with font tweaks from all font variants as I see fit.
Deterministic and pretty.

| Preview                              |
| ------------------------------------ |
| ![](.github/assets/mono_preview.png) |

## Building

This flake provides **4 packages** corresponding to different versions of the
same font. The differences are subtle, but noticeable. The main variants of
Ioshelfka are:

- Ioshelfka Mono
- Ioshelfka Term
- Ioshelfka Mono Nerdfont
- Ioshelfka Term Nerdfont

You may built any available variant with `nix build`. You may also call
`./nix/ioshelfka-base.nix` yourself if you'd like to apply your own tweaks _in
addition_ to what is available. Doing so invalidates any binary cache, but that
probably does not bother you.

```bash
# You may build the available variants without checking out to the repository
$ nix build github:notashelf/ioshelfka#ioshelfka-mono -Lv
```

## Installing

[GitHub Releases]: https://github.com/NotAShelf/Ioshelfka/releases

Nix users may access to the packages provided by the flake, as described in the
[building section](#building). This will cause the font to be built from source.
There is no functional binary cache, so this will take a bit of time and consume
a lot of resources.

Built packages are provided in the [GitHub Releases] tab, and get updated each
time a new tag is provided. This can be used by Nix users who simply want to
avoid building, or non-Nix users that cannot afford a proper package manager on
their system.

### With Nix

You'll probably install this as a part of your system configuration. In most
cases it'll be enough to add this to your `config.fonts.packages` and then use
the correct font name (as listed by `fontconfig`) in the application you want to
use Ioshelfka in. Some applications require font _files_, so you might need to
pass the full font path to those:

```nix
let
  ioshelfka = inputs.ioshelfka.packages.${pkgs.hostPlatform.system}.ioshelfka-term;
in {
  someConfig = ''
    fontPath = ${ioshelfka}/share/fonts/truetype/IoshelfkaTerm-Bold.ttf
  '';
}
```

To use fontconfig, you may refer to the font directly. For example, using the
Foot terminal:

```nix
{
  settings = {
    main.font = "IoshelfkaMono Nerd Font:size=15";
  };
}
```

## Credits

[@viperML]: https://github.com/viperML
[custom Iosevka build]: https://github.com/viperML/iosevka/
[build guide]: https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md

The build process is partially inspired by [@viperML]'s [custom Iosevka build].

Additionally, the [Iosevka customizer](https://typeof.net/Iosevka/customizer)
and the [build guide] found in the Iosevka repository have been very valuable
resources. Thank you!
