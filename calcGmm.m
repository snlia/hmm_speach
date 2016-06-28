%根据给定的gmm (Gaussian Mixture Models)，计算概率，并取对数
function p = calcGmm (gmm, x)

p = realmin; %防止log报错
for i = (1:gmm.K)
    p = p + gmm.w(i) * pdf (x, gmm.mu (i, :), gmm.sigma (i, :));
end

