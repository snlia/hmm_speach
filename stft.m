%///////////////////////////////////////////////////////////
% short time DFT analyse wav file
%///////////////////////////////////////////////////////////
close all;
clear;
clc;
% set target file at latter line
wav_fname              = 'baiyang_test.wav' ;
wav_fname              = 'dial_tone.wav'    ;

[wav_data, fs, q_bits] = wavread(wav_fname) ;
data_len               = length(wav_data)   ;
kaiser_beta            =  8                 ;

stdft_len_win          = 256               ;
stdft_len_overlap      = stdft_len_win-16  ;
stdft_len_dft          = stdft_len_win     ;

figure;
subplot(2,1,1);
plot(wav_data); title('Total signal');
subplot(2,1,2);
sect_len = 800;
plot(wav_data(1:sect_len));title('First part');

kaiser_win_spectrum_plot(fs, wav_data, kaiser_beta);
y_min = -160; y_max = 10;
ylim([y_min, y_max])    ;   % set y-axis range

title('Input Wave File, Normalized Spectrum', 'fontsize', 14);

dscp_str   = sprintf('fs %.2f KHz, L %d, q %d bits, beta %d',...
fs/1E3, data_len, q_bits, kaiser_beta);

text(0.5*(-fs/2),0.8*y_min,dscp_str, ...
     'FontSize',14, 'color', 'g','BackgroundColor','k') ;

len_w = stdft_len_win      ;   
len_o = stdft_len_overlap  ;  
len_d = stdft_len_dft      ;
figure  ;
% use tic toc get running time
tic     ;
spectrogram(wav_data, len_w, len_o, len_d, fs);
title('Spectrogram', 'fontsize', 14);
toc     ;
text_x = 0.7*(fs/2);
text_y = 0.5* (data_len/fs);
dscp_str = sprintf(' data len %d \n win len %d\n overlap %d\n dft len %d',...
           data_len, len_w, len_o, len_d);
text(text_x, text_y,dscp_str, ...
     'FontSize',14, 'color', 'g','BackgroundColor','k') ;
colormap('jet');
% plot 3d-mesh
S = spectrogram(wav_data, len_w, len_o, len_d, fs);
figure; mesh(log10(1E-4+abs(S))*10);
xlabel('Time', 'FontSize',14);
ylabel('Frequency', 'FontSize',14);
