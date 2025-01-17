#!/bin/bash
set -e

echo "Creating bootstrap for all archs"
# get the current path of the script
SCRIPTS_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPTS_PATH"
echo "Building proot..."
cd ../external/proot/

./build.sh

echo "Building minitar..."
cd ../minitar
./build.sh

cd $SCRIPTS_PATH
mkdir -p build
cd build
rm -rf *
cp ../ioctlHook.c .
../build-ioctl-hook.sh

cp -r ../../external/proot/build/* .

build_bootstrap () {
	echo "Packing bootstrap for arch $1"
	
	case $1 in
	aarch64)
		PROOT_ARCH="aarch64"
		ANDROID_ARCH="arm64-v8a"
		MUSL_ARCH="aarch64-linux-musl"
  		LINUX_CONTAINERS_ARCH="arm64"
		;;
	x86_64)
		PROOT_ARCH="x86_64"
		ANDROID_ARCH="x86_64"
		MUSL_ARCH="x86_64-linux-musl"
  		LINUX_CONTAINERS_ARCH="amd64"
		;;
	*)
		echo "Invalid arch"
		;;
	esac
	cd root-$PROOT_ARCH
	cp ../../../external/minitar/build/libs/$ANDROID_ARCH/minitar root/bin/minitar

	# separate binaries for platforms < android 5 not supporting 64bit
	if [[ "$1" == "armhf" || "$1" == "i386" ]]; then
		cp -r ../root-${PROOT_ARCH}-pre5/root root-pre5
		cp root/bin/minitar root-pre5/bin/minitar
	fi


	DEBIAN_VER="bullseye"
 
	echo "Finding Debian ($DEBIAN_VER) for $LINUX_CONTAINERS_ARCH"
  	R=$(curl -s 'https://images.linuxcontainers.org/meta/1.0/index-user' | grep "debian;$DEBIAN_VER;$LINUX_CONTAINERS_ARCH;default;")
   	P="${R##*;}"

    	echo "Downloading Debian ($DEBIAN_VER)"
     	curl --fail -o rootfs.tar.xz -L "https://images.linuxcontainers.org/$P/rootfs.tar.xz"
 
	cp ../../run-bootstrap.sh .
	cp ../../install-bootstrap.sh .
	cp ../../fake_proc_stat .
	cp ../../add-user.sh .
	cp ../build-ioctl/ioctlHook-${MUSL_ARCH}.so ioctlHook.so
	zip -r bootstrap-$PROOT_ARCH.zip root ioctlHook.so root-pre5 fake_proc_stat rootfs.tar.xz run-bootstrap.sh install-bootstrap.sh add-user.sh
	mv bootstrap-$PROOT_ARCH.zip ../
	echo "Packed bootstrap $1"
	cd ..
}

build_bootstrap aarch64
#build_bootstrap armhf
build_bootstrap x86_64
#build_bootstrap x86
