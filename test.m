%-------全局变量设定------
global theN; % 单词数量
global theM; % 采样数
global theWords; %单词集
%-------全局变量设定------
disp ('初始化参数...');
ignore = init;
disp ('分析各个单词的模板信息...');
for i = (1:theN)
    for j = (1:theM)
        [y, fs] = readwav (char (theWords (i)), int2str (j));
        [startp, endp] = vad (y);
        subplot(3,1,3);
        plot(y);
        axis([1,length(y),min(y),max(y)]);
        line([startp ,startp],[min(y),max(y)],'color','red');
        line([endp ,endp],[min(y),max(y)],'color','red');
        disp('显示端点……');
        sound (y(startp:endp));
        break;
    end;
end;

