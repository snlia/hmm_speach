%参数设定

function [ignore] = init

ignore = [];

global theN; % 单词数量
theN = 1; 
global theM; % 采样数
theM = 1; 

global theWords; %单词集
theWords = cell (1,theN); 
theWords = {'识别'};

