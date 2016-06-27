%对于一组向量进行混合高斯模型拟合
%输入samples为向量组，K为拟合的高斯函数数
function gmm = mkGmm (samples, K)

%用kmeans先求得初始模型
[res vect] = kmeans (samples, K); 

%对于kmeans分出每个类里面的向量，计算方差
for i = (1 : K)
    sigma(i, :) = std (samples (find (i == res) , :));
end

%根据kmeans的结果，计算权重
for i = (1 : K)
    w(i) = size (find (i == res), 1);
end

%归一
w = w / sum (w);

gmm.w = w; 
gmm.sigma = sigma.^2; 
gmm.mu = vect;
gmm.K = K;
