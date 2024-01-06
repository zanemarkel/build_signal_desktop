# Signal-Desktop-Fedora

A Dockerfile to build [Signal-Desktop](https://github.com/signalapp/Signal-Desktop) RPM package for Fedora!

Latest supported versions (can be configured):

- Fedora 39
- Signal-Desktop v6.43.0

## Usage

```bash
make
make install
```

## Signal version

I will try to keep this script up to date, but you can set the Signal-Desktop version in `SIGNAL_VERSION` file.

It should be a valid `tag` from <https://github.com/signalapp/Signal-Desktop/tags>

## Fedora version

Current supported Fedora version is 39, but you can change the version in `FEDORA_VERSION` file.

## Credits

Thanks to the Signal team, [yea-hung](https://github.com/signalapp/Signal-Desktop/issues/4530#issuecomment-1079834967), [michelamarie](https://github.com/michelamarie/fedora-signal/wiki/How-to-compile-Signal-Desktop-for-Fedora), and [BarbossHack](https://github.com/BarbossHack/Signal-Desktop-Fedora).

