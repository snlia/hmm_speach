%模板wav文件格式: 14307130244_word_id.wav , 存于文件夹data/word/中
%读入word和id，返回对应模板wav的读取信息，其中y为时域信息，fs为采样频率
function [y, fs] = readwav (name, word, id)

filename = strcat ('/home/snlia/work/speech/myspeech/data/', word);
filename = strcat (filename, '/');
filename = strcat (filename, name);
filename = strcat (filename, '_');
filename = strcat (filename, word);
filename = strcat (filename, '_');
filename = strcat (filename, id);
filename = strcat (filename, '.wav');

disp (strcat ('loading file ', filename));
disp (class (filename));

%[y, fs] = audioread ('/home/snlia/work/speech/myspeech/data/Start/14307130244_Start_1.wav');
[y, fs] = audioread (filename);
y=y.';

disp (strcat (strcat ('file ', filename), 'has been loaded'));
