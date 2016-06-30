%hmm(hidden Markov model)
%用隐马尔科夫模型训练样本集, 输入样本集，输出马尔科夫模型
%其中，A为转移矩阵,B为观测到状态的概率分布，即高斯模型，pi为初始向量
function [hmm] = hmmTrain (idex, samples, fs)

N = length (samples);

disp ('开始训练样本');

disp ('提取样本特征');

data = [];

for i = (1 : N)
    y = samples(i).x;
    [stp, edp, val] = vad (y, fs);
    data (i).x = mfcc (y (stp : edp), fs); %第i组样本特征
    data (i).val = val; %第i组样本权重
end

global theStates; %每个单词的状态数
S = theStates (idex); %对应的马尔科夫模型状态数量

hmm = initHmm (data, S);

%开始训练样本
for i = (1 : 10)
    hmm = BaumWelch (hmm, data);
    dispHmm (hmm);
    disp (i);
end

%saveHmm (hmm);

global theWords;
disp (strcat (strcat ('单词', char (theWords (idex))), '训练完成...'));
