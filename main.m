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
hmm = [];
for k = 1 : theWs
%    break;
    disp (strcat ('开始分析单词', theWords (k)));
    tot = 0;
    samples = [];
    for i = 1 : theNs
        for j = 1 : theMs
            %add ignore here
            [y, fs] = readwav (char (theNames (i)), char (theWords (k)), int2str (j));
            [startp, endp] = vad (y,fs);
          %  disp (startp);
          %  disp (endp);
          %  disp (size (y));
          %  sound (y (startp : endp));
            %pause ;
            tot = tot + 1;
            samples(tot).x = y;
        end
    end
    disp (strcat ( strcat ( strcat (strcat ('单词' ,theWords (k)), '样本提取完成，共采样'), int2str (tot)), '组'));
    disp ('开始训练...');
    hmm(k).x = hmmTrain (k, samples, fs);
    disp ('训练完成...储存模板...')
end
save ('caomao.mat', 'hmm');

load ('caomao.mat');
for i = (1:1)
    [y, fs] = readwav ('14307130166', 'Close', int2str (i));
    p = zeros (1, theWs);
    for i = (1 : theWs)
        p(i) = calcHmm (hmm (i).x, y, fs);
    end
    disp (p);
    disp (theWords (find (max (p) == p)));
end





