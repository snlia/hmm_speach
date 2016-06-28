%输出hmm模型
function [] = dispHmm (hmm)
disp ('A(转移矩阵):');
disp (hmm.A);
disp ('pi(初始向量):');
disp (hmm.pi);
%pause;
