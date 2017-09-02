#!/bin/bash
export LANG=C

USE_RAMDISK=true
NPROC=$1

[ -n "$NPROC" ] || NPROC=$(nproc)

echo "Install required packages"
sudo apt install build-essential || exit 1

if $USE_RAMDISK; then
  echo "Create compressed ramdisk (you need >16G(!) RAM)"
  sudo mkdir -p /mnt/ramdisk || exit 1
  sudo modprobe zram num_devices=1 || exit 1
  echo 64G | sudo tee /sys/block/zram0/disksize || exit 1
  sudo mke2fs -q -m 0 -b 4096 -O sparse_super -L zram /dev/zram0 || exit 1
  sudo mount -o relatime,nosuid /dev/zram0 /mnt/ramdisk/ || exit 1
  sudo mkdir -p /mnt/ramdisk/workdir || exit 1
  sudo chmod 777 /mnt/ramdisk/workdir || exit 1
  cp buildloop.sh /mnt/ramdisk/workdir/buildloop.sh || exit 1
  cd /mnt/ramdisk/workdir || exit 1
  mkdir tmpdir || exit 1
  export TMPDIR="$PWD/tmpdir"
fi

echo "Download GCC sources"
wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-7.1.0/gcc-7.1.0.tar.bz2 || exit 1

echo "Extract GCC sources"
tar xf gcc-7.1.0.tar.bz2 || exit 1

echo "Download prerequisites"
(cd gcc-7.1.0/ && ./contrib/download_prerequisites)

[ -d 'buildloop.d' ] && rm -r 'buildloop.d'
mkdir -p buildloop.d || exit 1

echo "cat /proc/cpuinfo | grep -i -E \"(model name|microcode)\""
cat /proc/cpuinfo | grep -i -E "(model name|microcode)"
echo "sudo dmidecode -t memory | grep -i -E \"(rank|speed|part)\" | grep -v -i unknown"
sudo dmidecode -t memory | grep -i -E "(rank|speed|part)" | grep -v -i unknown
echo "uname -a"
uname -a
echo "cat /proc/sys/kernel/randomize_va_space"
cat /proc/sys/kernel/randomize_va_space

journalctl -kf | sed 's/^/[KERN] /' &
echo "Using ${NPROC} parallel processes"

START=$(date +%s)
for ((I=0;$I<$NPROC;I++)); do
  (taskset -c $I ./buildloop.sh "loop-$I" || echo "TIME TO FAIL: $(($(date +%s)-${START})) s") | sed "s/^/\[loop-${I}\] /" &
  sleep 1
done

wait
