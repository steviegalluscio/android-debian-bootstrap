#!/system/bin/sh

chmod -R 777 ../
chmod -R +rx ../
# unpack debian bootstrap
mkdir bootstrap
cd bootstrap
cat ../rootfs.tar.xz | ../root/bin/minitar
cd ..

# create resolv.conf
rm -f bootstrap/etc/resolv.conf
echo "nameserver 8.8.8.8 \n \
nameserver 8.8.4.4" > bootstrap/etc/resolv.conf
# make resolv.conf immutable
chattr +i bootstrap/etc/resolv.conf

echo "bootstrap ready, run with run-bootstrap.sh"
