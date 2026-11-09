function [str,bld] = dssimMap(repImgs)
% repImgs: repeated images Z-X-N
% str: structural image
% bld: blood flow image
str=mean(repImgs,3);
ssimMap=zeros(size(repImgs));
for i=1:size(repImgs,3)
    [~,ssimMap(:,:,i)]=ssim(repImgs(:,:,i), str);
end
bld=mean(ssimMap,3);
bld=(1-bld)./2; % calculate DSSIM
end
