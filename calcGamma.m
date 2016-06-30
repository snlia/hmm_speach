%给定样本集以及hmm模型，求状态转移概率分布gamma，以及每个高斯函数的匹配概率xi
function [gamma, xi] = calcGamma (hmm, sample)

pi = hmm.pi; %初始概率
A = hmm.A; %转移矩阵
B = hmm.B; %转移矩阵
T = size (sample, 1); %观察序列/样本长度
N = hmm.N; %状态数

b = zeros (T, N);
%提前计算概率矩阵
for i = (1 : T)
    for j = (1 : N)
        b(i, j) = calcGmm (B (j), sample (i, :));
    end
end

%求前向概率矩阵alpha
%为了保证精度不爆炸，这里引入tmp(t)表示从t - 1时刻转移到t时刻的时候符合hmm模型的概率
%则prod (tmp(1:t))表示到t时刻满足hmm模型的概率的倒数(倒数精度比较难炸)
%那么令alpha(t,i)表示第t时刻，在i状态的概率占所有状态概率
%则，第t时刻，在i状态的前向概率可以表示为alpha(t, i) / prod (tmp (1: t)) 

%初始化
alpha = zeros (T, N);
for i = (1 : N)
    alpha (1, i) = pi (i) * calcGmm (B (i), sample (1, :));
end

tmp = ones (1, T);
tmp (1) = 1 / sum (alpha (1, :));
alpha (1, :) = alpha (1, :) * tmp (1);


for i = (2 : T)
    for j = (1 : N)
        for k = (1 : N)
            alpha (i, j) = alpha (i, j) + alpha (i - 1, k) * A (k, j) * b (i, j);
        end
    end
    tmp (i) = 1 / sum (alpha (i, :));
    alpha (i, :) = alpha (i, :) * tmp (i);
end


%求后向概率矩阵beta
%同样为了保证精度不爆炸，需要引入一个变量，这里仍然用tmp，原因在报告中说明
%有第t时刻，在i状态的后向概率可以表示为beta (t, i) / prod (tmp (t : T)) 

%初始化
beta  = zeros (T, N);
beta (T, :) = tmp (T) * ones (1, N);

for i = (T - 1 :-1: 1)
    for j = (1 : N)
        for k = (1 : N)
            beta (i, j) = beta (i, j) + beta (i + 1, k) * A (j, k) * b (i + 1, k);
        end
    end
    beta (i, :) = beta (i, :) * tmp (i);
end

%计算gamma
gamma = zeros (T - 1, N, N);
for i = (1 : T - 1)
    for j = (1 : N)
        for k = (1 : N)
            gamma (i, j, k) = alpha (i, j) * beta (i + 1, k) * A (j, k) * b (i + 1, k);
        end
    end
end
gamma = gamma / sum (alpha (T, :));

%
gama = zeros(T,N,3);
for t = 1:T
	pab = zeros(N,1);
	for l = 1:N
		pab(l) = alpha(t,l) * beta(t,l);
	end
	x = sample(t,:);
	for l = 1:N
		prob = zeros(B(l).K,1);
		for j = 1:B(l).K
			m = B(l).mu(j,:);
			v = B(l).sigma (j,:);
			prob(j) = B(l).w(j) * pdf(x, m, v);
		end
        if ((sum (pab) > 0) && (sum (prob) > 0))
            tmp  = pab(l)/sum(pab);
            for j = 1:B(l).K
                gama(t,l,j) = tmp * prob(j)/sum(prob);
            end
        else
            for j = 1:B(l).K
                gama(t, l, j) = B(l).w(j);
            end
        end;
    end
end

xi = gama;
