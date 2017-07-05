close all;
clear;
clc;
fs = 44100;
process_data = @(x) mvn(sgbfb(log_mel_spectrogram(x,fs)));
while true
  level = -round(rand(1).*100);
  data_in = 10.^(level./20).*randn(fs.*3,1);
  data_out_ref = process_data(data_in);
  for i=1:100
    data_out = process_data(data_in);
    if ~all(data_out(:) == data_out_ref(:)) 
      printf('ERROR! %e\n',max(abs(data_out(:) - data_out_ref(:))));
      exit 1;
    end
  end
end
