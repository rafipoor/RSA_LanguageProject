clear;
close all;
%%
load('ModelRDMS.mat');
load('WholeBrainBetaMatrix.mat');
load('SearchLighIdx.mat');
BetaMatrix      = Beta(1:numel(CondLabels),:);
[nCond,nVoxels] = size(BetaMatrix);
nModels         = numel(ModelRDMs);
%%
PermRepeats = 10;
%%
PValues     = zeros(nVoxels,nModels);
RDMCorrs    = zeros(nVoxels,nModels);
TrilMask    = ~(triu(ones(nCond))==1);

parfor i = 1:6
    VoxIdx   = SearchLightIdx(i,:);
    Pattern  = BetaMatrix(:,VoxIdx);
    DataRDM  = pdist(Pattern)';
    for j = 1:nModels
        RDMCorrs(i,j) = corr(DataRDM,ModelRDMs{j},'rows','complete');
        PermCorrs     = zeros(PermRepeats,1);
        IncludedConds = find(sum(~isnan(SqModelRDMs{j}))>1);
        for ii = 1:PermRepeats
            Ordering = 1:nCond;
            Ordering(IncludedConds) = IncludedConds(randperm(numel(IncludedConds)));
            PermRef  = SqModelRDMs{j}(Ordering,Ordering);
            PermCorrs(ii)= corr(PermRef(TrilMask),DataRDM(:),'rows','complete');
        end
        PValues(i,j) = ksdensity(PermCorrs,RDMCorrs(i,j),'Function','cdf');
    end
    disp(i);
end
save('ModelsTestResults.mat','RDMCorrs','PValues');
