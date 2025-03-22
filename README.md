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

By defautl, pasym reads the file `manifest.pasym`. You can provide a custom path as an argument.

```
./pasym <manifest_file>
```

[GNU Stow]: https://www.gnu.org/software/stow/
