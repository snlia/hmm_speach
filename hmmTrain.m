%hmm(hidden Markov model)
%用隐马尔科夫模型训练样本集, 输入样本集，输出马尔科夫模型
%其中，A为转移矩阵,B为观测状态的高斯模型，pi为初始向量
function [hmm] = hmmTrain (idex, samples, fs)

N = length (samples);

disp ('开始训练样本');

disp ('提取样本特征');

for i = (1 : N)
    y = samples(i).x;
    [stp, edp, val] = vad (y, fs);
    if (val == 0) continue; 
    end;
    data (i).x = mfcc (y (stp : edp), fs); %第i组样本特征
    data (i).val = val; %第i组样本权重
end

global theStates; %每个单词的状态数
S = theStates (idex); %对应的马尔科夫模型状态数量

hmm = initHmm (data, S);

