close all;
clear;
Alpha     = 0.05;
Corrected = true;
load('ModelRDMS.mat');
%%
for SIdx = 1:27
   SubjFolder = sprintf('subject%d',SIdx);
   ResDir     = fullfile('..','Results',SubjFolder);
   ResFile    = fullfile(ResDir,'TestModelRDMsResults.mat');
   load(ResFile);
   MaskFile   = fullfile('..','Data','NiiFiles','subject27','mask.nii');
   VMask      = spm_vol(MaskFile);
   Mask       = spm_read_vols(VMask);

   TempFile   = fullfile('..','Data','NiiFiles','subject27','beta_0001.nii');
   VTemp      = spm_vol(TempFile);
   for mIdx = 1:numel(ModelRDMs)
        % corrs:
        Output  = zeros(size(Mask));
        Output(Mask(:)==1) = zscore(Corrs(:,mIdx));
        VTemp.fname  = sprintf('Subj%d_%s_Corr.nii',SIdx,ModelNames{mIdx});
        spm_write_vol(VTemp,Output);
        spm_image('Display',VTemp.fname);
        movefile(VTemp.fname,ResDir,'f');
        
        % pvalues:
        Output  = zeros(size(Mask));
        Output(Mask(:)==1) = PValues(:,mIdx);
        VTemp.fname = sprintf('Subj%d_%s_PVals.nii',SIdx,ModelNames{mIdx});
        spm_write_vol(VTemp,Output);
        spm_image('Display',VTemp.fname);
        movefile(VTemp.fname,ResDir,'f');
        
        %sig
        Output = zeros(size(Mask));
        if Corrected; Alpha = Alpha/size(PValues,1); end %#ok<*UNRCH>
        Output(Mask(:)==1) = PValues(:,mIdx) > 1-Alpha;
        VMask.fname = sprintf('Subj%d_%s_Sig.nii',SIdx,ModelNames{mIdx});
        spm_write_vol(VMask,Output);
        spm_image('Display',VMask.fname);
        movefile(VMask.fname,ResDir,'f');
    end
end
