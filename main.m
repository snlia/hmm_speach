%-------全局变量设定------
global theWs; % 单词数量
global theNs; % 学号数量
global theMs; % 采样数
global theWords; %单词集
global theNames; %学号集
%-------全局变量设定------
disp ('初始化参数...');
ignore = init;
disp ('分析各个单词的模板信息...');
for k = 1 : theWs
    disp (strcat ('开始分析单词', theWords (k)));
    tot = 0;
    for i = 1 : theNs
        for j = 1 : theMs
            %add ignore here
            [y, fs] = readwav (char (theNames (i)), char (theWords (k)), int2str (j));
            [startp, endp] = vad (y,fs);
            sound (y (startp : endp));
            %pause ;
            tot = tot + 1;
            samples (tot).x = y;
        end
    end
    disp (strcat ( strcat ( strcat (strcat ('单词' ,theWords (k)), '样本提取完成，共采样'), int2str (tot)), '组'));
    disp ('开始训练...');
    [hmm] = hmmTrain (k, samples, fs);
    disp ('训练完成...储存模板...')
end

 
