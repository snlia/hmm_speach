%参数设定

function [ignore] = init

ignore = [];

global N; % 单词数量
N = 1; 
global M; % 采样数
M = 20; 

global words; %单词集
words = cell (1,N); 
words = {'Happy'};

