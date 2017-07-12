# ryzen-test
Script to reproduce randomly crashing processes under load on AMD Ryzen processors on Ubuntu 17.04.

# Try it
Run

> ./kill-ryzen.sh

and watch teh output.

# Method
This script will download GCC sources (version 7.1) and build GCC in parallel loops on a compressed ramdisk.
Each loop requires several Gb of disk space (and here, RAM in this case).
Building other software packages might work just as well; the script could be easily adapted.

# Effect
Processes related to the build will eventually crash (e.g., segfault).
Processes unrelated to the build process might crash as well.
An example output of the script where the first process crashed after 153 seconds can be found in "example-output.txt".
There, the "last words" from the build process were (logged to "/mnt/ramdisk/workdir/buildloop.d/loop-*/build.log"):
> Makefile:761: recipe for target 'get_patches.lo' failed
> make[5]: *** [get_patches.lo] Segmentation fault (core dumped)

# Requirements
To sucessfully finish one round of builds more than 16Gb of RAM are required because GCC is a large software package.
However, very often, one of the parallel build fails long before 16Gb of RAM are actually used (in the example, e.g, at about 2.2Gb total RAM usage).
You can try it, but it will fail if you run out of memory (should it if you have sufficient swap space?).
The use of a compressed ramdisk can also be switched off by replacing "USE_RAMDISK=true" with "USE_RAMDISK=false", but seems to increase the "TIME TO FAIL".
Alternatively, smaller software packages could be tried (suggestions welcome).

# TODO
Extend logs:
* Temperatures
* CPU usage
* I/O wait
* Memory usage

