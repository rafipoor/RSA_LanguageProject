clear;
close all;
%%


%% make Model RDM
[~,CondLabels] = xlsread('Stimuli list RSA.xlsx');
CondLabels    = CondLabels(1:end);
nCond         = numel(CondLabels);
CondTypes     = {'Light','Non-Light','Anomolous'};
NonLightConds = contains(CondLabels,CondTypes{2});
LightConds    = contains(CondLabels,CondTypes{1}) & ~NonLightConds;
AnomCond      = contains(CondLabels,CondTypes{3});


%% model 1 : pairwise difference
ModelNames{1} = 'Pairwise Class';
ModelPattern  = double([LightConds NonLightConds AnomCond]);
ThisModelRDM  = pdist(ModelPattern)';
ModelRDMs{1}  = ThisModelRDM/max(ThisModelRDM);

%% model2: light vs all:
ModelNames{2}  = 'Light vs all';
ModelPattern   = double(LightConds);
ThisModelRDM   = pdist(ModelPattern)';
ModelRDMs{2}   = ThisModelRDM/max(ThisModelRDM);


%% model3 : NonLight vs all
ModelNames{3}  = 'NonLight vs all';
ModelPattern   = double(NonLightConds);
ThisModelRDM   = pdist(ModelPattern)';
ModelRDMs{3}   = ThisModelRDM/max(ThisModelRDM);

%% model 4: Anomolous vs all
ModelNames{4} = 'Anomalous vs all';
ModelPattern  = double(AnomCond);
ThisModelRDM  = pdist(ModelPattern)';
ModelRDMs{4}  = ThisModelRDM/max(ThisModelRDM);

%% model 5: light vs nonlinght:
ModelNames{5} = 'Light vs NonLight';
ModelPattern  = double([LightConds NonLightConds]);
ThisModelRDM  = squareform(pdist(ModelPattern));
ThisModelRDM(AnomCond==1,:) = nan;
ThisModelRDM(:,AnomCond==1) = nan;
ThisModelRDM  = ThisModelRDM(~(triu(ones(nCond))==1));
ModelRDMs{5}  = ThisModelRDM/max(ThisModelRDM);

%% model 6: light vs anom:
ModelNames{6} = 'Light vs Anomalous';
ModelPattern  = double([LightConds AnomCond]);
ThisModelRDM  = squareform(pdist(ModelPattern));
ThisModelRDM(NonLightConds==1,:) = nan;
ThisModelRDM(:,NonLightConds==1) = nan;
ThisModelRDM  = ThisModelRDM(~(triu(ones(nCond))==1));
ModelRDMs{6}  = ThisModelRDM/max(ThisModelRDM);

%% model 7: nonlight vs anom:
ModelNames{7} = 'NonLight vs Anomalous';
ModelPattern  = double([NonLightConds AnomCond]);
ThisModelRDM  = squareform(pdist(ModelPattern));
ThisModelRDM(LightConds==1,:) = nan;
ThisModelRDM(:,LightConds==1) = nan;
ThisModelRDM  = ThisModelRDM(~(triu(ones(nCond))==1));
ModelRDMs{7}  = ThisModelRDM/max(ThisModelRDM);

SqModelRDMs    = cellfun(@squareform,ModelRDMs,'UniformOutput',false);

%% visualize all rdms
[r,c] = find([LightConds NonLightConds AnomCond]);
xt    = grpstats(r,c,'mean');
ax    = tight_subplot(2,4);
for i = 1:numel(ModelRDMs)
    axes(ax(i)); %#ok<LAXES>
    imagesc(SqModelRDMs{i},'AlphaData',1-.5*isnan(SqModelRDMs{i}));
    axis('square');
    title(ModelNames{i}); colorbar; axis('square');
end
axes(ax(8));
axis('off');
set(ax(1:7),'XTick',xt,'XTickLabel',CondTypes,'YTick',xt,...
    'YTickLabel',CondTypes,'YTickLabelRotation',90,'XAxisLocation','top');
MyPrint('AllModelRDMs.png');

save('ModelRDMS','ModelRDMs','ModelNames','SqModelRDMs','CondLabels');
