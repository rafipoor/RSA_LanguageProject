clear;
close all;

Model    = 1;
ResDir   = '../Results/Group';
load('ModelRDMs');

userOptions = projectOptions_demo();
userOptions.rootPath = [pwd,filesep,'TFCE'];
userOptions.analysisName = 'TFCE';

MaskFile   = fullfile('..','Data','NiiFiles','subject1','mask.nii');
V          = spm_vol(MaskFile);
Mask       = spm_read_vols(V);

AnatFile   = fullfile('..','Data','NiiFiles','structuralgroupmean.nii');
V          = spm_vol(AnatFile);
AnatVol    = spm_read_vols(V);
AnatVol    = cat(1,AnatVol,zeros(2,size(AnatVol,2),size(AnatVol,3)));
AnatVolRs  = imresizen(AnatVol,1/3);

for Model = 1:7
    fName     = sprintf('%s_Group_TFCE_PVals.nii',ModelNames{Model});
    NiiFile   = fullfile(ResDir,fName);
    V         = spm_vol(NiiFile);
    FuncVol       = spm_read_vols(V);
    brainVol      = rsa.fmri.addRoiToVol(map2vol(AnatVolRs),mask2roi(Mask),[1 0 0],2);
    brainVol_tfce = rsa.fmri.addBinaryMapToVol(brainVol,FuncVol,[1 1 0]);
    rsa.fig.showVol(brainVol_tfce,'TFCE: P < .05',3)
end
