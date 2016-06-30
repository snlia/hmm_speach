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
%hmm.pi = zeros (1, N);
%for i = (1 : N)
%    for j = (1 : T)
%        hmm.pi (i) = hmm.pi (i) + data (j).val * (pi (i) * calcGmm (B(i), data(j).x (1, :)));
%    end
%end
%hmm.pi = hmm.pi / sum (hmm.pi);

%计算新的转移矩阵
hmm.A  = zeros (N, N);
for i = (1 : N)
    for j = (1 : N)
        for k = (1 : T)
            tmp1 = gamma (k).x (:, i, j);
            tmp2 = gamma (k).x (:, i, :);
            if (sum (tmp1(:)) > 0) 
                hmm.A (i, j) = hmm.A (i, j) + sum (tmp1(:)) / sum (tmp2(:)) * data (k).val; 
            end
        end
    end
end
for i = (1 : N)
%    hmm.A (i, :) = hmm.A (i, :) / sum (hmm.A (i, :));
end
hmm.A = hmm.A / allValue;

%更新混合高斯模型

for i = (1 : N)
    hmm.B(i).w = zeros (1, B(i).K);
    for j = (1 : B (i).K)
        newMu = zeros (1, size (data(1).x, 2));
        newSigma = zeros (1, size (data(1).x, 2));
        tsum = 0;
        for k = (1 : T)
            for t = (1 : size (data(k).x, 1))
                x = data (k).x (t, :);
                newMu = newMu + x * (xi (k).x (t, i, j) * data (k).val);
                newSigma = newSigma + ((x - B(i).mu(j,:)).^2) * (xi (k).x (t, i, j) * data (k).val);
                tsum = tsum + xi (k).x (t, i, j);
            end
        end
        if (tsum > 0) newMu = newMu / tsum; end;
        if (tsum > 0) newSigma = newSigma / tsum; end;
        hmm.B(i).mu (j, :) = newMu;
        hmm.B(i).sigma (j, :) = newSigma;

        tp = 0;
        tsum = 0;
        for k = (1 : T)
            tmp = xi (k).x (:,i,j);
            tp = tp + data (k).val * sum (tmp (:));
            tmp = xi (k).x (:,i,:);
            tsum = tsum + data (k).val * sum (tmp (:));
        end
        if (tp > 0) hmm.B(i).w(j) = tp / tsum; 
        else hmm.B(i).w(j) = 0; 
        end;
    end
    hmm.B(i).K = B(i).K;
end
