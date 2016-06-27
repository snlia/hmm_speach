function p = viterbi (hmm, sample)

%将模型中的数据取对数，以保留精度
pi = log (hmm.pi); %初始概率
A = log (hmm.A); %转移矩阵
T = size (sample, 2); %观察序列/样本长度
N = hmm.N; %状态数

%初始化
f = (ones (T, N)) * (-inf);
for i = (1 : N)
    f(1, i) = init(i) + calcGmm (hmm.B(i), sample (1, :));
end

%计算转移方程
for i = (2 : T)
    for j = (1 : N)
        for k = (1 : N)
            f (i, j) = min (f (i, j), f(i - 1, k) + A (j, k) + calcGmm (hmm.B(j), sample (i, :)));
        end
    end
end

p = exp (max (f (N, :)));
