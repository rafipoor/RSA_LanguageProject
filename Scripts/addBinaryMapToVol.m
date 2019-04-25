function vol=addBinaryMapToVol(vol, sigs, corrs)


%% MARK THE VOXELS
toBeMarked_INDs = find(sigs==1);
Pallet  = colormap('hot');
Pallet  = Pallet(32:end,:); 
[~,Idx] = sort(corrs(toBeMarked_INDs));
ColIdx  = ceil(Idx/max(Idx) *size(Pallet,1));
Colors  = Pallet(ColIdx,:);

volXYZ3  = permute(vol,[1 2 4 3]);
redmap   = volXYZ3(:,:,:,1);
greenmap = volXYZ3(:,:,:,2);
bluemap  = volXYZ3(:,:,:,3);

redmap(toBeMarked_INDs)   = Colors(:,1);
greenmap(toBeMarked_INDs) = Colors(:,2);
bluemap(toBeMarked_INDs)  = Colors(:,3);

volXYZ3(:,:,:,1)= redmap;
volXYZ3(:,:,:,2)= greenmap;
volXYZ3(:,:,:,3)= bluemap;

vol=permute(volXYZ3,[1 2 4 3]);
end