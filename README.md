# pasym

pasym is a symbolic link generator similar to [GNU Stow] written in Pascal.

# Disclaimer
pasym is a learning project and is **not** meant for production use.
If you happen to stumble upon this, please use it with caution.

# Quick Start

``` console
fpc pasym.fpc
./pasym
```

By default, pasym reads the file `manifest.pasym`. You can provide a custom path as an argument.

``` console
./pasym [manifest_file] [options...]
```

# Manifest File Format

- Manifest file is parsed line by line.
- Each line should state a source and a target.
- Pasym parses lines in manifest file by `->`. Left side is the file/directory to be linked and right side is the target path.

```
<source> -> <target>
```

# Options
- -d/--dry: Pasym runs in dry mode, not creating links.

# Feature Plans
- `Partial linking` User might want to link only certain files in manifest file.
- `Link removal` pasym should be able to work in reverse and remove the links it created. This should also support partial removal.

[GNU Stow]: https://www.gnu.org/software/stow/
