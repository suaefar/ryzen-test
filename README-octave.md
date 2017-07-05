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

Watch output for errors ("panic")
(won't appear in dmesg, seem to be catched by Octave itself)

