clear;
close all;
%%
load('WholeBrainBetaMatrix.mat');
load('SearchLighIdx.mat');
BetaMatrix      = Beta(1:222,:);
[nCond,nVoxels] = size(BetaMatrix);


%% make Model RDM
[~,CondLabels] = xlsread('Stimuli list RSA.xlsx');
CondLabels    = CondLabels(1:222);
CondTypes     = {'Light','Non-Light','Anomolous'};
NonLightConds = contains(CondLabels,CondTypes{2});
LightConds    = contains(CondLabels,CondTypes{1}) & ~NonLightConds;
AnomCond      = contains(CondLabels,CondTypes{3});
ModelPattern  = double([LightConds NonLightConds AnomCond]);
ModelRDM      = pdist(ModelPattern)';
ModelRDM      = ModelRDM/max(ModelRDM);
SqModelRDM    = squareform(ModelRDM);
imagesc(SqModelRDM);
xlabel('Conditions'); ylabel('Conditions');
[r,c] = find(ModelPattern);
xt  = grpstats(r,c,'mean');
set(gca,'XTick',xt,'XTickLabel',CondTypes,'YTick',xt,...
    'YTickLabel',CondTypes,'YTickLabelRotation',90);
title('Model RDM'); colorbar;
axis('square');
MyPrint('ModelRDM.png');

%% Compute RDM Correlations
PermRepeats  = 100;
PValues      = zeros(nVoxels,1);
Correlations = zeros(nVoxels,1);
TrilMask     = tril(ones(nCond))==0;

for i = 1:nVoxels
    VoxIdx   = SearchLightIdx(i,:);
    Pattern  = BetaMatrix(:,VoxIdx);
    DataRDM   = pdist(Pattern)';
        
    Correlations(i) = corr(DataRDM,ModelRDM);
    PermCorrs  = zeros(PermRepeats,1);
    for ii = 1:PermRepeats
        Ordering = randperm(nCond);
        PermRef  = SqModelRDM(Ordering,Ordering);
        PermCorrs(ii)= corr(PermRef(TrilMask),DataRDM(:));
    end
    PValues(i) = ksdensity(PermCorrs,Correlations(i),'Function','cdf');
end
save('Model1.mat','Correlations','PValues','ModelRDM');

%% Save SPM mats and visualize the results
V    = spm_vol(fullfile('output','mask.nii'));
Mask = spm_read_vols(V);

Output = zeros(size(Mask));
Output(Mask(:)==1) = Correlations*100;
V.fname = 'Model1Corrs.nii';
spm_write_vol(V,Output);
spm_image('Display',V.fname);

Alpha = 0.01;
Output = zeros(size(Mask));
Output(Mask(:)==1) = PValues > 1-Alpha;
V.fname = 'Model1Sig.nii';
spm_write_vol(V,Output);
spm_image('Display',V.fname);
