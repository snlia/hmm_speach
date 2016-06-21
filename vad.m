%起/终点判断函数
%输入一个时域采样信息y与采样频率fs，返回发音部分的起点与终点。
function [startp, endp] = vad (y, fs)

%将数值映射到[-1, 1], 方便参数设定

y = double (y);
y = y / max(abs(y));

%设定参数

framelen = fs * 0.02; % 20ms
frameinc = framelen * 0.5; % 桢长一半

%幅度归一化到[-1,1]

y = double(y);
max_y = max(abs(y));
y = y / max_y;

%计算短时过零率szcr (short-time zero crossing rate)

theTmp = enframe_muti (y(1:end - 1), ones (1, framelen), framelen, frameinc);
theTmpp = enframe_muti (y(2:end), ones (1, framelen), framelen, frameinc);
theTmppp = abs (theTmp - theTmpp);
theEsp = min (max (theTmppp(1)), max (theTmppp(length(theTmppp))));
szcr = sum ((theTmp.*theTmpp < 0) .* (abs (theTmp - theTmpp) > theEsp), 2); %过零且两点值相差大于theEsp

%计算短时幅度 sm(short-term magnitude)

sm = sum (abs (theTmp.*theTmp), 2);

%设定幅度上下门限,theMh, theMl, 之间判断为浊音段。

theMh = max (sm) / 4;
theMl = max (sm) / 16;

%设定过零率门限theZ0

theZ0 = max (szcr)*0.09;
disp (max  (szcr));

%设定一些变量

theLen = length (szcr); %分出多少帧

%第一步，通过theMh判断浊音段

figure, subplot(4,1,1);
plot (sm);
axis([1,length(sm),min(sm),max(sm)]);

for startp = (1:theLen)
    if (sm(startp) >= theMh) 
        break;
    end;
end;

for endp = (theLen:-1:1)
    if (sm(endp) >= theMh) 
        break;
    end;
end;

line([startp ,startp],[min(sm),theMh],'color','green');
line([endp ,endp],[min(sm),theMh],'color','green');

%第二步，通过theMl向两边拓宽浊音段

for startp = (startp:-1:1)
    if (sm(startp) <= theMl) 
        break;
    end;
end;

for endp = (endp:theLen)
    if (sm(endp) <= theMl)
        break;
    end;
end;

line([startp ,startp],[min(sm),theMl],'color','red');
line([endp ,endp],[min(sm),theMl],'color','red');

%第三步，通过短时过零率判断前后轻音段

subplot(4,1,2);
plot (szcr);
axis([1,length(szcr),min(szcr),max(szcr)]);

for startp = (startp:-1:1)
    if (szcr(startp) <= theZ0)
        break;
    end;
end;

for endp = (endp:theLen)
    if (szcr(endp) <= theZ0)
        break;
    end;
end;

line([startp ,startp],[min(szcr),max(szcr)],'color','red');
line([endp,endp],[min(szcr),max(szcr)],'color','red');

startp = (frameinc - 1) * startp;
endp = (frameinc - 1) * endp;
