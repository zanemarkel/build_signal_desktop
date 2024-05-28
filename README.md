# Signal-Desktop-Fedora

A Dockerfile to build a [Signal-Desktop](https://github.com/signalapp/Signal-Desktop) RPM package for Fedora.

Latest tested versions (can be configured):

- Fedora 40
- Signal-Desktop v7.10.0

## Usage

```bash
make
make install
```

## Signal version

I will try to keep this script up to date, but you can set the Signal-Desktop version in the `SIGNAL_VERSION` file.

It should be a valid `tag` from <https://github.com/signalapp/Signal-Desktop/tags>

## Fedora version

You can change the version in the `FEDORA_VERSION` file.

## Credits

Thanks to the Signal team, [yea-hung](https://github.com/signalapp/Signal-Desktop/issues/4530#issuecomment-1079834967), [michelamarie](https://github.com/michelamarie/fedora-signal/wiki/How-to-compile-Signal-Desktop-for-Fedora), and [BarbossHack](https://github.com/BarbossHack/Signal-Desktop-Fedora).

