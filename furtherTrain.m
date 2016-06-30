%用来迭代训练模型

function [] = furtherTrain ()
%-------全局变量设定------
global theWs; % 单词数量
global theNs; % 学号数量
global theMs; % 采样数
global theWords; %单词集
global theNames; %学号集
init;
%导入模型集
load ('caomao.mat');

trainWord = '商行';

for idex = (1:theWs)
    if (strcmp (trainWord, char (theWords (idex)))) break; end;
end;

disp (idex);

disp (strcat ('开始分析单词', theWords (idex)));
tot = 0;
samples = [];
for i = 1 : theNs
    for j = 1 : theMs
        [y, fs] = readwav (char (theNames (i)), char (theWords (idex)), int2str (j));
        if (fs == 0) continue; end
        [startp, endp, val] = vad (y,fs);
        %if (startp > endp) pause; end;
        disp (val);
        if (val == 0) continue; end;
                %     sound (y (startp:endp));
                %     pause;
        tot = tot + 1;
        samples(tot).x = y;
    end
end
disp (strcat ( strcat ( strcat (strcat ('单词' , trainWord), '样本提取完成，共采样'), int2str (tot)), '组'));
disp ('提取样本特征');

N = length (samples);
data = [];
for i = (1 : N)
    y = samples(i).x;
    [stp, edp, val] = vad (y, fs);
    data (i).x = mfcc (y (stp : edp), fs); %第i组样本特征
    data (i).val = val; %第i组样本权重
end

disp ('开始训练');
global theStates; %每个单词的状态数
S = theStates (idex); %对应的马尔科夫模型状态数量

for i = (1:5)
    dispHmm (hmm(idex).x);
    hmm(idex).x = BaumWelch (hmm(idex).x, data);
    dispHmm (hmm(idex).x);
    disp (i);
    disp ('正在保存...');
    save ('caomao.mat', 'hmm');
    disp ('保存成功!');
end
