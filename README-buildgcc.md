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

Start compiling (RIP)
> ./threadripper-buildgcc.sh

Watch for errors
> journalctl -kf

To stop the scripts
> killall buildloop.sh
> killall make
(or restart the machine)

