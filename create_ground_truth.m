clear;
close all;
clc;

% Load training data of a particular target class. Must contain at least a
% variable called snips containing the training image data. 
load training_data
% for i = 1:26
[nrow,ncol,nsnips]=size(snips);
cmax=255; % Max colormap value in image plot
scalefac=1; % Scale factor of y axis wrt x axis 
T=200; % This will be T, the number of sample points, in the remaining programs

% Set image index one at a time instead of doing a for-loop. You will mess 
% up from time to time using the hand_segment function
i=5; 

% Manually trace ground truth target boundary. Return boundary curve 
% betatrain as well as Ctrue, the ground truth region matrix (0's for 
% background pixels, 1's for target)
I=snips(:,:,i);
[Ctrue(:,:,i),betatrain{i}]=hand_segment(I,T,scalefac,cmax);
% [Ctrue(:,:,i),betatrain{i}]=auto_segment(I,T,scalefac,cmax);

% Plot results to see if they are acceptable.
curves{1}=betatrain{i};
plot_curves_on_image(curves,I,nrow,scalefac,1,2,cmax,'r');
plot_curves_on_image(curves,Ctrue(:,:,i),nrow,scalefac,2,2,2,'r'); colormap jet;
% end
% Save results to the same file name as above. Update this file one image 
% at a time, carefully. 
save('training_data.mat','snips','Ctrue','betatrain','scalefac');

