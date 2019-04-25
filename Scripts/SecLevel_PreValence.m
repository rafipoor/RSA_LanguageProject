clear;
close all;
ResDir   = '../../../Desktop/PermResults';
Model    = 1;
Perm2    = 10000;
Alpha    = 0.05;

fName = fullfile(ResDir,sprintf('GroupPermDataModel%d.mat',Model));
load(fName);
[res,params] = prevalenceCore(Data,Perm2,Alpha);
fName = fullfile(ResDir,sprintf('GroupSeconLevelModel%d.mat',Model));
save(fName,'res','params');
