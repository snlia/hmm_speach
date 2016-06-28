a.a = 0;
a.b = 1;
a.c = 2;
save('test.mat','a');
a.a = 212;
load ('test.mat');
a