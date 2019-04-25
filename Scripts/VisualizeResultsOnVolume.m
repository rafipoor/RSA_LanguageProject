clear;
close all;
load('ModelRDMs');
Alpha      = 0.01;
MaskFile   = fullfile('..','Data','NiiFiles','subject1','mask.nii');
V          = spm_vol(MaskFile);
Mask       = spm_read_vols(V);

AnatFile   = fullfile('..','Data','NiiFiles','structuralgroupmean.nii');
V          = spm_vol(AnatFile);
AnatVol    = spm_read_vols(V);
AnatVol    = cat(1,AnatVol,zeros(2,size(AnatVol,2),size(AnatVol,3)));
AnatVolRs  = imresizen(AnatVol,1/3);

brainVol   = rsa.fmri.addRoiToVol(map2vol(AnatVolRs),mask2roi(Mask),[1 0 0],2);
for subject  = 1:27
    SubjFolder = sprintf('subject%d',subject);
    ResDir     = fullfile('..','Results',SubjFolder);
    ResFile    = fullfile(ResDir,'TestModelRDMsResults.mat');
    load(ResFile);    
    FigsDir  = sprintf('../Figures/FirstLevel/subject%d',subject);
    mkdir(FigsDir);
    
    for mdl = 1:7
        CorVol             = zeros(size(Mask));
        CorVol(Mask(:)==1) = Corrs(:,mdl);

        PValVol  = zeros(size(Mask));
        PValVol(Mask(:)==1) = zscore(PValues(:,mdl));
        SigsVol = PValVol > 1-Alpha;
        FuncVol = addBinaryMapToVol(brainVol,SigsVol,CorVol);
        rsa.fig.showVol(FuncVol,ModelNames{mdl},3)
        MyPrint(sprintf('%s/%s.png',FigsDir,ModelNames{mdl}));
    end
end