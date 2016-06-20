%模板wav文件格式: 14307130244_word_id.wav , 存于文件夹data/word/中
%读入word和id，返回对应模板wav的读取信息，其中y为时域信息，fs为采样频率
function [y, fs] = readwav (word, id)

filename = strcat ('/home/snlia/work/speech/myspeech/data/', word);
filename = strcat (filename, '/14307130244_');
filename = strcat (filename, word);
filename = strcat (filename, '_');
filename = strcat (filename, id);
filename = strcat (filename, '.wav');

disp (strcat ('loading file ', filename));

[y, fs] = audioread (filename);
y=y.';

disp (strcat (strcat ('file ', filename), 'has been loaded'));
