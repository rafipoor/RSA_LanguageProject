
clear;
close all;

nPerms   = 10000;
Alpha    = 0.05;
Model    = 1;

ResDir   = '../Results/Group';
mkdir(ResDir);

Subjects = 1:27;
nSubj    = numel(Subjects);


load('ModelRDMs');

MaskFile   = fullfile('..','Data','NiiFiles','subject1','mask.nii');
V          = spm_vol(MaskFile);
Mask       = spm_read_vols(V);
Data       = nan([size(Mask),nSubj]);

TemplateFile   = fullfile('..','Data','NiiFiles','subject1','beta_0001.nii');
Vtemp          = spm_vol(TemplateFile);
for Model = 1:7
    for SIdx = 1:nSubj
        fName      = 'TestModelRDMsResults.mat';
        SubjFolder = sprintf('subject%d',SIdx);
        load(fullfile('..','Results',SubjFolder,fName));
        sData      = Corrs(:,Model);
        tmp        = nan(size(Mask));
        tmp(Mask == 1) = sData;
        Data(:,:,:,SIdx) = tmp;
    end
    
    PVals        = matlab_tfce_ttest_onesample(Data,1,nPerms,2,.5,26,0.1);
    Vtemp.fname  = sprintf('%s_Group_TFCE_PVals.nii',ModelNames{Model});
    spm_write_vol(Vtemp,PVals);
    spm_image('Display',Vtemp.fname);
    movefile(Vtemp.fname,ResDir,'f');
    
    Sigs     = zeros(size(Mask));
    Sigs(PVals<Alpha) = 1;
    V.fname  = sprintf('%s_Group_TFCE_Sigs.nii',ModelNames{Model});
    spm_write_vol(V,Sigs);
    spm_image('Display',V.fname);
    movefile(V.fname,ResDir,'f');
end
