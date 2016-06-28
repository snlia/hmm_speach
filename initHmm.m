%根据数据生成初始的hmm矩阵
%初始转移矩阵为呈指数梯度下降矩阵，初始状态全为1
%将样本截成长度相同的段构建状态的混合高斯模型
%其中，A为转移矩阵,B为观测到状态的概率分布，即高斯模型，pi为初始向量
function [hmm] = initHmm (data, S)

hmm.N = S;

%构建初始状态向量
hmm.pi = zeros (1, S);
hmm.pi(1) = 1;

%构建初始转移矩阵
for i = (1 : S)
    hmm.A(i,i) = 1;
    for j = (i + 1 : S)
        hmm.A(i,j) = hmm.A(i,j - 1) * 0.5; %转移到下个状态的概率呈指数下降
    end
    for j = (i - 1:-1:1)
        hmm.A(i,j) = hmm.A(i, j + 1) * 0.25; %转移到前面状态的概率更低
    end
end

%归一
for i = (1 : S)
    hmm.A(i, :) = hmm.A(i, :) / sum (hmm.A(i, :));
end

%B为对角阵

%构建初始gmm

N = length (data);

for i = (1 : S)
    allsample = [];
    for j = (1 : N)
        sample = data(j).x;
        M = size (sample, 1); %样本长度
        len = ceil (M / S);
        stp = floor (1 + (i - 1) * len); %状态起点
        edp = min (floor (1 + i * len), M); %状态终点
        for k = (1 : data(j).val)
            allsample = [allsample; sample(stp:edp,:)];
        end
    end
    hmm.B (i) = mkGmm (allsample, 3); %进行高斯模型计算，设定每个高斯模型由3组高斯函数混合
end

