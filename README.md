# ryzen-test
Tools to reproduce randomly crashing processes under load on AMD Ryzen processors on Ubuntu 17.04.


## Build GCC (very effective) ##
Build GCC (Version 7.1) in a loop and in parallel

Install build-essential
> sudo apt install build-essential

Create ramdisk (you will need lots of RAM)
> sudo mkdir -p /mnt/ramdisk
> sudo mount -t tmpfs -o size=28G tmpfs /mnt/ramdisk

Change to ramdisk
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


## Octave (less effective) ##
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





