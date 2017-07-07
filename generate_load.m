close all;
clear;
clc;
fs = 44100;
process_data = @(x) mvn(sgbfb(log_mel_spectrogram(x,fs)));
error_count = 0;
while true
  level = -round(rand(1).*100);
  data_in = 10.^(level./20).*randn(fs.*3,1);
  data_out_ref = process_data(data_in);
  for i=1:1000
    data_out = process_data(data_in);
    if ~all(data_out(:) == data_out_ref(:))
      error_count = error_count + 1;
      printf('\nthis probably should not happen! (%i) (but could be rounding issues) %f\n',error_count,max(abs(data_out(:) - data_out_ref(:))));
    end
  end
end
