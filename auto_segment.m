function [C,beta] = auto_segment(I,T,scalefac,cmax)

[nrow,ncol]=size(I);

% figure(1); imagesc(I); colormap gray; axis tight off; caxis([0,cmax]); daspect([1 1/scalefac 1]);
% h=imfreehand;
% betapix=getPosition(h);
% betapix(end+1,:)=betapix(1,:);
% [ct,~,~,~] = get_contours(I);
% betapix = ct{1}';
betapix = big_contour(I);
[beta(:,1),beta(:,2)]=pixel_to_cartesian(betapix(:,2),betapix(:,1),nrow,scalefac);
beta=ReSampleCurve(beta,T);
betapix=zeros(T,2);
[betapix(:,2),betapix(:,1)]=cartesian_to_pixel(beta(:,1),beta(:,2),nrow,scalefac);
C=poly2mask(betapix(:,1)',betapix(:,2)',nrow,ncol);