# android-debian-bootstrap
Fork of [feelfreelinux/android-linux-bootstrap](https://github.com/feelfreelinux/android-linux-bootstrap) for debian instead of alpine.


Debian Linux bootstrap archives for aarch64 and x86_64 only, targeting Android API 16+.


## Setup

To setup the bootstrap, extract it anywhere and run:
`./install-bootstrap.sh`

This will extract and setup the bundled debian linux rootfs. You can later access it by using the `run-bootstrap.sh` script.

This script uses [green-green-avk's proot build script](https://github.com/green-green-avk/build-proot-android).
