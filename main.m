%-------全局变量设定------
global N; % 单词数量
global M; % 采样数
global words; %单词集
%-------全局变量设定------
disp ('初始化参数...');
ignore = init;
disp ('分析各个单词的模板信息...');
for i = 1 : N
    for j = 1 : M
        [y, fs] = readwav (char (words (i)), int2str (j));
        [startp, endp] = vad (y, fs);
        k = y (startp : endp);
    end
end
