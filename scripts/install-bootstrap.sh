#!/system/bin/sh

chmod -R 777 ../
chmod -R +rx ../
# unpack debian bootstrap
mkdir bootstrap
cd bootstrap
cat ../rootfs.tar.xz | ../root/bin/minitar
cd ..

# create resolv.conf
rm -r bootstrap/etc/resolv.conf 2>/dev/null || true
echo "nameserver 8.8.8.8 \n \
nameserver 8.8.4.4" > bootstrap/etc/resolv.conf
# make resolv.conf immutable
chattr +i bootstrap/etc/resolv.conf

# fix in-memory filesystem directories by creating /var/lock or /run/lock
cat <<EOF > bootstrap/etc/profile.d/fix-env.sh
[ -L '/var/lock' -a ! -e '/var/lock' ] && mkdir -p "\$(readlink -m '/var/lock')" || true
EOF

echo "bootstrap ready, run with run-bootstrap.sh"
