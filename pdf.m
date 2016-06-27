%返回给定mu和sigma下的gd(Gaussian distribution)值
function p = gd (x, mu, sigma)
p = (2 * pi * prod(sigma)) ^ -0.5 * exp (-0.5 * (x - mu) ./ sigma * (x - mu)');
