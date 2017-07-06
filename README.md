# ryzen-test
Tools to reproduce randomly crashing processes under load on AMD Ryzen processors on Ubuntu 17.04.


## Build GCC (very effective) ##
Build GCC (Version 7.1) in a loop and in parallel

Install build-essential
> sudo apt install build-essential

Create compressed ramdisk
(you will still need lots of RAM! probably >16G)
You can try to go without this step and just work on your disk
> sudo mkdir -p /mnt/ramdisk

> sudo modprobe zram num_devices=1

> echo 64G | sudo tee /sys/block/zram0/disksize

> sudo mke2fs -q -m 0 -b 4096 -O sparse_super -L zram /dev/zram0

> sudo mount -o relatime,nosuid,umask=0000 /dev/zram0 /mnt/ramdisk/

Change to ramdisk directory
> cd /mnt/ramdisk

Download source code from
> https://gcc.gnu.org/mirrors.html

E.g.,
> wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-7.1.0/gcc-7.1.0.tar.bz2

Extract source code
> tar xf gcc-7.1.0.tar.bz2

Download required prerequisites (including parenthesis!)
> (cd gcc-7.1.0/ && ./contrib/download_prerequisites)

Copy buildloop.sh and threadripper.sh to current folder

Make them executable
> chmod +x buildloop.sh threadripper.sh

Start building GCC (RIP)
> ./threadripper-buildgcc.sh

Watch for errors
> journalctl -kf

To stop the scripts
> killall buildloop.sh

> killall make
(or restart the machine)


## Octave (much less effective) ##
Extract features for robust automatic speech recognition from noise signals with Octave 

Install GNU/Octave
> sudo apt install octave liboctave-dev build-essential

Install octave packages
> echo "pkg install -forge -auto general control signal" | octave-cli -q

Clone code repository
> git clone https://github.com/m-r-s/reference-feature-extraction.git

Copy generate_load.m and threadripper-octave.sh to current folder

Make script executable
> chmod +x threadripper-octave.sh

Start extracting robust features for automatic speech recognition from noise signals
> ./threadripper-octave.sh

Ignore the warnings at the start
Watch output for errors ("panic")
(segfaults won't appear in dmesg, seem to be catched by Octave itself)





