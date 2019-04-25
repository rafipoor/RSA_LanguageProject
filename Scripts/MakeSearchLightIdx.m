clear;
v    = spm_vol(fullfile('output','mask.nii'));
Mask = spm_read_vols(v);
nVoxels = sum(Mask(:) ==1);

SearchLightSize = 3;% voxels
nNeighbours    = SearchLightSize^3;
SearchLightIdx = zeros(nVoxels,nNeighbours);

x = find(Mask);
[y1,y2,y3] = ind2sub(size(Mask),x);
Pos = [y1,y2,y3];

for i=1:nVoxels
    Center   = Pos(i,:);
    [~,Idx]  = sort(pdist2(Pos,Center));
    SearchLightIdx(i,:) = Idx(1:nNeighbours);
end
save('SearchLighIdx','SearchLightIdx');
