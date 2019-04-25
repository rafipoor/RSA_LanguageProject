clear;
close all;
ResDir   = '../../../Desktop/PermResults';
Here     = pwd;
cd(ResDir);
Subjects = 1:9;
nSubj    = numel(Subjects);
nPerms   = 100;
nVox     = 66046;
nModels  = 7;
Model    = 1;
Data     = nan(nVox,1 + nPerms, nSubj);

for i = 1:nSubj
    fName = fullfile(sprintf('subject%d',Subjects(i)),'TestModelRDMsResults.mat');
    load(fName);
    Data(:,:,i) = [Corrs(:,Model) squeeze(PermCorrs(:,Model,1:nPerms))];
end
save(sprintf('GroupPermDataModel%d.mat',Model),'Data');
cd(Here);
