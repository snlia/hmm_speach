%给定Hmm模型以及样本，输出其概率

function p = calcHmm (hmm, sample, fs)

[stp, edp, val] = vad (sample, fs);
data = mfcc (sample (stp : edp), fs);

p = viterbi (hmm, data);
