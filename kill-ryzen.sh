#!/bin/bash
export LANG=C

USE_RAMDISK=true
CLEAN_ON_EXIT=false
NPROC=$1
TPROC=$2
MOUNTPOINT="/mnt/ramdisk"

[ -n "$NPROC" ] || NPROC=$(nproc)
[ -n "$TPROC" ] || TPROC=1

cleanup() {
  sudo rm -rf /mnt/ramdisk/*
  sudo umount /mnt/ramdisk
}
if $CLEAN_ON_EXIT; then
  trap "cleanup" SIGHUP SIGINT SIGTERM EXIT
fi

echo "Install required packages"
if which apt-get &>/dev/null; then
  sudo apt-get install build-essential
elif which dnf &>/dev/null; then
  sudo dnf install -y @development-tools
elif which pacman &>/dev/null; then
  echo "You are using a rolling release distribution based on ArchLinux. You are on your own if things fail."
  sudo pacman -S --needed base-devel
else
  echo "Your distribution is not officially supported. The script will continue but may fail if you don't have the required build tools. You are on your own if things fail."
fi

if $USE_RAMDISK; then
  #Create compressed ramdisk if it doesn't already exist
  if mountpoint -q $MOUNTPOINT; then
    echo "RAMdisk already mounted on $MOUNTPOINT."
  else
    echo "Create compressed ramdisk"
    sudo mkdir -p $MOUNTPOINT || exit 1
    sudo modprobe zram num_devices=1 || exit 1
    # Setting maximum RAM disk size
    echo 64G | sudo tee /sys/block/zram0/disksize || exit 1
    sudo mkfs.ext4 -q -m 0 -b 4096 -O sparse_super -L zram /dev/zram0 || exit 1
    sudo mount -o relatime,nosuid,discard /dev/zram0 $MOUNTPOINT || exit 1
  fi
  sudo mkdir -p $MOUNTPOINT/workdir || exit 1
  sudo chmod 777 $MOUNTPOINT/workdir || exit 1
  cp buildloop.sh $MOUNTPOINT/workdir/buildloop.sh || exit 1
  cd $MOUNTPOINT/workdir || exit 1
  mkdir -p tmpdir || exit 1
  export TMPDIR="$PWD/tmpdir"
fi

echo "Download GCC sources"
DOWNLOAD_FILE=gcc-7.2.0.tar.xz
wget -O "$DOWNLOAD_FILE" -c ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-7.2.0/$DOWNLOAD_FILE || exit 1

echo "Extract GCC sources"
tar xf $DOWNLOAD_FILE || exit 1

echo "Download prerequisites"
(cd gcc-7.2.0/ && ./contrib/download_prerequisites)

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

# start journal process in different working directory
pushd /
  journalctl -kf -o short-iso | sed 's/^/[KERN] /' &
popd
echo "Using ${NPROC} parallel processes"

START=$(date +%s)
for ((I=0;$I<$NPROC;I++)); do
  (./buildloop.sh "loop-$I" "$TPROC" || echo "TIME TO FAIL: $(($(date +%s)-${START})) s") | sed "s/^/\[loop-${I}\] /" &
  sleep 1
done

wait
