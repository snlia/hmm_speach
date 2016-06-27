%参数设定

function [ignore] = init

ignore = [];

global theNs; % 学号数量
theNs = 1; 
global theWs; %单词数量
theWs = 1;
global theMs; % 采样数
theMs = 20; 

global theWords; %单词集
theWords = cell (1,theWs); 
theWords = {'Start'};

global theNames; %学号集
theNames = cell (1,theNs); 
theNames = {'14307130244'};

global theStates; %每个单词的状态数
theStates = [5];
