# ryzen-test
Script to reproduce randomly crashing processes under load on AMD Ryzen processors on _Ubuntu 17.04_(!).

# Try it
Run

> ./kill-ryzen.sh

and watch the output.

# Update/revert: The codebase is frozen
As I do not have faulty Ryzen CPUs anymore to test the script with new versions of the GCC software package, other distributions, etc...
and because the main goal is to reproducibly trigger the bug: I will not accept _any_ changes to the code!

To get as close as possible to the conditions that I had when testing my CPUs, you should run the script on a Ubuntu 17.04. live system, e.g., from a USB drive WITHOUT ANY UPDATES. This code will serve as a reference. You can fork it and I will happily add links to derived versions here.

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
To successfully finish a round of 16 builds more than 16Gb of RAM are required because GCC is a large software package.
However, very often, one of the parallel build fails long before 16Gb of RAM are actually used (in the example, e.g, at about 2.2Gb total RAM usage).
You can try it, but it will fail if you run out of memory (should it if you have sufficient swap space?).
The use of a compressed ramdisk can also be switched off by replacing "USE_RAMDISK=true" with "USE_RAMDISK=false", but seems to increase the "TIME TO FAIL".
Alternatively, smaller software packages could be tried (suggestions welcome).

You can also try to run fewer loops but allow them to use more threads, e.g., 8 loops with 2 threads each.

> ./kill-ryzen.sh 8 2

However, with only 16Gb RAM, this configuration might still run out of memory.
4 loops with 4 threads each is a safe choice on machines with 16Gb RAM.

> ./kill-ryzen.sh 4 4

# Update on my experience (suaefar)
I wrote this script to reproducibly show that there was a severe problem with my early (adopted) Ryzen processor.
First, I experienced segfaults (a few per day) while performing simulations with complex, partly undocumented code that probably only few care about [1,2].
_Compiling_ the GNU _compiler_ collection (GCC) with the GCC seemed much more suitable to demonstrate the problem (ruling out bad code) and was already proposed in an AMD community thread [3] and elsewhere.
Parallel builds with -j 1 seemed to even increase the load and probability to hit the problem, sometimes after only a few seconds.

A few days ago, I got a replacement from AMD for my affected Ryzen R7 1700.
It survived more than 24 accumulated hours (4*8h) of parallel GCC compilation without a single crashed process.
My simulations (about 24h of calculations) were completed without any error.
I have not experienced a single segfault until now (2017-10-31).

[1] https://github.com/m-r-s/fade

[2] https://github.com/HoerTech-gGmbH/openMHA

[3] https://community.amd.com/thread/215773
