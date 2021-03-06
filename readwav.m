%模板wav文件格式: 14307130244_word_id.wav , 存于文件夹data/word/中
%读入word和id，返回对应模板wav的读取信息，其中y为时域信息，fs为采样频率
function [y, fs] = readwav (name, word, id)

if (length (id) == 1) id = strcat ('0', id);end;

filename = strcat ('/home/snlia/work/speech/myspeech/SpeechDataset/', name);
filename = strcat (filename, '/');
filename = strcat (filename, name);
filename = strcat (filename, '_');
filename = strcat (filename, word);
filename = strcat (filename, '_');
filename = strcat (filename, id);
filename = strcat (filename, '.wav');

if (exist (filename, 'file') == false) 
    fs = 0; y = 0;
    return;
end

disp (strcat ('loading file ', filename));
disp (class (filename));

%[y, fs] = audioread ('/home/snlia/work/speech/myspeech/data/Start/14307130244_Start_1.wav');
[y, fs] = audioread (filename);
y=y.';

disp (strcat (strcat ('file ', filename), 'has been loaded'));
