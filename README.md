# pasym

pasym is a symbolic link generator similar to [GNU Stow] written in Pascal.

# Disclaimer
pasym is a learning project and is **not** meant for production use.
If you happen to stumble upon this, please use it with caution.

# Quick Start

``` console
make
./pasym
```

By default, pasym reads the file `manifest.pasym`. You can provide a custom path as an argument.

``` console
./pasym [options...] [name] [manifest_file]
```

# Manifest File Format

- Manifest file is parsed line by line.
- Each line should state a name, source and a target.

```
<name>: <source> -> <target>
```

# Options
- -d/--dry: pasym runs in dry mode, not creating links. Can be used to confirm paths.
- -o/--only: Only link specific entries in manifest file. Requires a [name] argument immediatly after. Multiple entries can be specified using commas:`nvim,kitty,polybar`

``` console
# short form, one entry
./pasym -o nvim

# long form, multiple entries with custom manifest fiel
./pasym --only nvim,kitty,polybar manifest_file
```

# Future Plans
- Handle duplicate naming.
- `Link removal` pasym should be able to work in reverse and remove the links it created. This should also support partial removal.

[GNU Stow]: https://www.gnu.org/software/stow/
