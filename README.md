# Ioshelfka

[Iosevka]: https://typeof.net/Iosevka

Home-baked [Iosevka] builds created for personal use. Based on the FiraCode
template, with font tweaks from all font variants as I see fit.

| Preview                              |
| ------------------------------------ |
| ![](.github/assets/mono_preview.png) |

## Building

4 packages are provided by the flake.

- Ioshelfka Mono
- Ioshelfka Term
- Ioshelfka Mono Nerdfont
- Ioshelfka Term Nerdfont

You may build any variant available in `flake.nix` using Nix.

```bash
$ nix build github:notashelf/ioshelfka#ioshelfka-mono -Lv
```

Note that this enables parallel building by default, which will likely run your
system out of resources. Reconsider your life choices if this is a problem for
you.

## Installing

Nix users may access the package directly from the flake outputs.

Non-nix users might want to try their luck with GitHub releases, which gets
fresh builds of the fonts whenever I release a tag.

## Credits

[@viperML]: https://github.com/viperML
[custom Iosevka build]: https://github.com/viperML/iosevka/
[build guide]: https://github.com/be5invis/Iosevka/blob/main/doc/custom-build.md

The build process is partially inspired by [@viperML]'s [custom Iosevka build].

Additionally, the [Iosevka customizer](https://typeof.net/Iosevka/customizer)
and the [build guide] found in the Iosevka repository have been very valuable
resources. Thank you!
