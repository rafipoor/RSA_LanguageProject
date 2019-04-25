clear;
close all;

%% parameters:
PermRepeats = 500;

%%
Subjects = 1:27;
DataFolder = '../Data';
load('ModelRDMS.mat');
load(fullfile(DataFolder,'SearchLight','SearchLighIdx.mat'));
nModels         = numel(ModelRDMs);

%%
for si = 1:numel(Subjects)
    
    SId          = Subjects(si);
    SubjFolder   = sprintf('subject%d',SId);
    OutputFolder = fullfile('..','PermResults',SubjFolder);
    mkdir(OutputFolder);

    LogFile    = fopen(fullfile(OutputFolder,'log.txt'),'w');
    fprintf(LogFile,'started\n');
    fprintf('Subject %d processing started\n',SId);
    InputFile  = fullfile(DataFolder,'BetaMatrices',SubjFolder,'WholeBrainBeta');
    load(InputFile);
    
    BetaMatrix      = Beta(1:numel(CondLabels),:);
    [nCond,nVoxels] = size(BetaMatrix);
    PValues    = zeros(nVoxels,nModels);
    Corrs      = zeros(nVoxels,nModels);
    PermCorrs  = zeros(nVoxels,nModels,PermRepeats);
    TrilMask   = ~(triu(ones(nCond))==1);
    
    parfor vId = 1:nVoxels
        VoxIndx  = SearchLightIdx(vId,:);
        Pattern  = BetaMatrix(:,VoxIndx);
        DataRDM  = pdist(Pattern)';
        for mId = 1:nModels
            Corrs(vId,mId) = corr(DataRDM,ModelRDMs{mId},'rows','complete');
            NullCorrs     = zeros(PermRepeats,1);
            IncludedConds = find(sum(~isnan(SqModelRDMs{mId}))>1);
            for pid = 1:PermRepeats
                Ordering = 1:nCond;
                Ordering(IncludedConds) = IncludedConds(randperm(numel(IncludedConds)));
                PermRef        = SqModelRDMs{mId}(Ordering,Ordering);
                NullCorrs(pid) = corr(PermRef(TrilMask),DataRDM(:),'rows','complete');
            end
            PValues(vId,mId) = ksdensity(NullCorrs,Corrs(vId,mId),'Function','cdf');
            PermCorrs(vId,mId,:) = NullCorrs;
        end
        if mod(vId,5000)==0
            fprintf('voxel %d done\n',vId);
        end
    end
    OutputFile = fullfile(OutputFolder,'TestModelRDMsResults');
    save(OutputFile,'Corrs','PValues','PermCorrs');
    fprintf(LogFile,'finished\n');
    fclose(LogFile);
    fprintf('Subject %d processing finished\n',SId);
end
