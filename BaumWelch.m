%用BaumWelch算法训练hmm
%输入样本集以及上次hmm，返回迭代训练后的hmm

function hmm = BaumWelch (hmm, data)

%一些变量的定义
N = hmm.N;
pi = hmm.pi; %初始概率
A = hmm.A; %转移矩阵
B = hmm.B; %转移矩阵
T = length (data); %样本数量
allValue = 0;

gamma = [];
xi = [];
for i = (1 : T)
    [gamma(i).x, xi(i).x] = calcGamma (hmm, data(i).x);
    allValue = allValue + data (i).val;
end

%计算新的初始状态
hmm.pi = zeros (1, N);
for i = (1 : N)
    for j = (1 : T)
        hmm.pi (i) = hmm.pi (i) + data (j).val * (pi (i) * calcGmm (B(i), data(j).x (1, :)));
    end
end
hmm.pi = hmm.pi / sum (hmm.pi);

%计算新的转移矩阵
hmm.A  = zeros (N, N);
for i = (1 : N)
    for j = (1 : N)
        for k = (1 : T)
            hmm.A (i, j) = hmm.A (i, j) + sum (gamma (k).x (:, i, j)) * data (k).val; 
        end
    end
end
hmm.A (i, j) = hmm.A (i, j) / allValue;

%更新混合高斯模型

for i = (1 : N)
    for j = (1 : B (i).K)
        newMu = zeros (1, size (data(1).x, 2));
        newSigma = zeros (1, size (data(1).x, 2));
        tsum = 0;
        for k = (1 : T)
            for t = (1 : size (data(k).x, 1))
                x = data (k).x (t, :);
                newMu = newMu + x * (xi (k).x (t, i, j) * data (k).val);
                newSigma = newSigma + ((x - B(i).mu(j,:)).^2) * (xi (k).x (t, i, j) * data (k).val);
                tsum = tsum + xi (k).x (t, i, j) * data (k).val;
            end
        end
        newMu = newMu / tsum;
        newSigma = newSigma / tsum;
        hmm.B(i).mu (j, :) = newMu;
        hmm.B(i).sigma (j, :) = newSigma;

        tp = 0;
        tsum = 0;
        for k = (1 : T)
            tmp = xi (k).x (:,i,j);
            tp = tp + data (i).val * sum (tmp (:));
            tmp = xi (k).x (:,i,:);
            tsum = tsum + data (i).val * sum (tmp (:));
        end
        hmm.B(i).w(j) = tp / tsum;
    end
    hmm.B(i).K = B(i).K;
end
