clear;
close all;
DataFolder = '../Data/NiiFiles';
nSubjects  = 27;

for Sub=22:nSubjects
    SubjFolder = sprintf('subject%d',Sub);
    v    = spm_vol(fullfile(DataFolder,SubjFolder,'mask.nii'));
    Mask = spm_read_vols(v);
    
    
    files       = dir(fullfile(DataFolder,SubjFolder));
    nConditions = sum(contains({files.name},'beta'));
    nVoxels     = sum(Mask(:)==1);
    
    Beta  = zeros(nConditions,nVoxels);
    for i = 1:numel(files)
        if contains(files(i).name,'beta')
            v    = spm_vol(fullfile(DataFolder,SubjFolder,files(i).name));
            m    = spm_read_vols(v);
            tmp  = strsplit(files(i).name,{'_','.'});
            cIdx = str2double(tmp{2});
            Beta(cIdx,:) = m(Mask(:)==1);
        end
    end
    FolderName = fullfile('../Data/BetaMatrices/',SubjFolder);
    mkdir(FolderName);
    save(fullfile(FolderName,'WholeBrainBeta'),'Beta','Mask');
end