%-------全局变量设定------
global theN; % 单词数量
global theM; % 采样数
global theWords; %单词集
%-------全局变量设定------
disp ('初始化参数...');
ignore = init;
disp ('分析各个单词的模板信息...');
for i = 1 : N
    for j = 1 : M
        [y, fs] = readwav (char (theWords (i)), int2str (j));
        [startp, endp] = vad (y, fs);
        k = y (startp : endp);
    end
end
