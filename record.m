% 运行平台：Mac OSX，MATLAB R2014b
% 录音录2秒钟
function [] = record ()
    Time = 2;

    FS = 8000;
    nBits = 16;
    recObj = audiorecorder(FS, nBits, 1);
    disp('Start speaking.')
    recordblocking(recObj, Time);
    disp('End of Recording.');

    myRecording = getaudiodata(recObj);

    filename = 'tmp.wav';
    audiowrite(filename, myRecording, FS)
