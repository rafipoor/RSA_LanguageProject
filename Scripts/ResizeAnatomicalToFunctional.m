clear;
close all;


AnatFile   = fullfile('..','Data','NiiFiles','structuralgroupmean.nii');
V          = spm_vol(AnatFile);
AnatVol    = spm_read_vols(V);
AnatVol    = cat(1,AnatVol,zeros(2,size(AnatVol,2),size(AnatVol,3)));
AnatVolRs  = imresizen(AnatVol,1/3);

MaskFile   = fullfile('..','Data','NiiFiles','subject22','beta_0001.nii');
V          = spm_vol(MaskFile);
V.fname    = 'ScaledStructural.nii';
spm_write_vol(V,AnatVolRs);