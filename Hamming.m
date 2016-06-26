%Hamming 汉明窗函数
%提供桢长Len，返回一个长度为Len的1×Len的汉明窗矩阵

function res = Hamming (Len)
res = hamming (len);
res = res.';

