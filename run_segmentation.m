clear;
close all;
clc;

%% Load image data and prior parameters

load test_image_snips       % Load test image snippets "snips" and known ground truth curves "betatrue"   
load prior                  % Load Sprior structure for a single target class   

i=2;                        % Select index of image snippet to segment

% Set weighting coefficients
lambda(1)=0.5;              % Eimage_pix weight
lambda(2)=40;               % Eshape (target) weight
lambda(3)=2;                % Elength (target) weight
lambda(4)=0.002;            % Esmooth (target) weight

% Gradient computation type: 0 for analytical gradient computation, 1 for numerical gradient computation
gradtype(1)=0; 
gradtype(2)=1;
gradtype(3)=0;
gradtype(4)=1;


%% Initialize Active Contour Algorithm

% Manually set
Sinit.type='refined'; % (manual, prior, coarse-refined, refined)
Sinit.ntheta=20;
Sinit.delta=1;
Sinit.maxit=100;
Sinit.toggleplot=true;
Sinit.cmax=255;
Sinit.display_iter=false;

% Automatically computed
Sinit.lambda=lambda;
Sinit.I=log(double(snips(:,:,i)));                   % Log-transformed image
Sinit.scalefac=Sprior.scalefac;              % Scale factor of y axis wrt x axis 
Sinit.T=length(Sprior.Sbetamean.beta');     % Number of sample points along active contour
Sinit.t=linspace(0,1,Sinit.T);               % Time at each sample point
[Sinit.nrow,Sinit.ncol]=size(Sinit.I);       % Dimensions of image
[Sinit.uu,Sinit.vv]=generate_coordinates(Sinit.nrow,Sinit.ncol,Sinit.scalefac); % x and y coordinates of each pixel (meshgrid)
Sinit.gradtype=gradtype;

% v = VideoWriter('initialization_step.avi');
% v.FrameRate = 10;
% open(v);


% Initialize active contour algorithm
% profile on
tic
[Sopt.beta0,Eevol0]=initialize_active_contour(Sinit,Sprior);
toc
% profile viewer
% profile off

% close(v)


% Display initialization
curves{1}=Sopt.beta0;
plot_curves_on_image(curves,exp(Sinit.I),Sinit.nrow,Sinit.scalefac,1,2,Sinit.cmax,'r')
if strcmp(Sinit.type,'refined')
    figure; plot(Eevol0);
end
% pause;

%% Energy optimization via active contour

% Manually set
Sopt.delta=0.1;             % Step size for gradient descent
Sopt.epsilon=10^-2;         % Perturbation factor used in numerical gradient calculation
Sopt.maxit=100;             % Maximum number of iterations
Sopt.tol=10^-6;             % Tolerance for stopping criterion
Sopt.d=20;                  % Number of Fourier basis elements
Sopt.toggleplot=true;       % Plot the active contour evolution
Sopt.cmax=255;               % Image colorbar scale maximum (threshold for plotting) 
Sopt.resample_iter=true;   % Uniformly sample curve after every iteration (set to false if using 'agm')
Sopt.display_iter=false;    % Display iteration number and energy in command window 
Sopt.algorithm='grad';       % Algorithm type ('grad','agm','none')

% Automatically computed
Sopt.lambda=lambda;
Sopt.I=Sinit.I;                         % Log of image snippet
Sopt.scalefac=Sprior.scalefac;          % Scale factor of y axis wrt x axis 
Sopt.T=Sinit.T;                         % Number of sample points along active contour
Sopt.t=Sinit.t;                         % Time at each sample point
Sopt.fbasis=create_basis(Sopt.d,Sopt.T);% Fourier basis elements
Sopt.nrow=Sinit.nrow;                   % Dimensions of sonar image
Sopt.ncol=Sinit.ncol;                   
Sopt.uu=Sinit.uu;                       % x and y coordinates of each pixel (meshgrid)
Sopt.vv=Sinit.vv;
Sopt.gradtype=gradtype;


% u = VideoWriter('active_contour_step.avi');
% u.FrameRate = 10;
% open(u);


% tic
% profile on;
tic
[betahat,Eevol,error]=optEtotal(Sopt,Sprior);
toc
% profile viewer;
% profile off;
% toc

% close(u)


%% Display results

curves{1}=betahat;
plot_curves_on_image(curves,exp(Sopt.I),Sopt.nrow,Sopt.scalefac,1,2,Sopt.cmax,'r');
figure(2); clf; plot(Eevol,'LineWidth',2);
title('Energy Evolution of Active Contour Algorithm');
disp(['Final Energy: ' num2str(Eevol(end))]);

% Measure difference from ground truth segmentation, if there is one 
% available (shape distance and binary image metric in CVPR2014) 
[dshape,dbin]=compare_to_ground_truth(betahat,betatrue{i},Sopt.nrow,Sopt.ncol,Sopt.scalefac);
disp(['Shape Distance: ' num2str(dshape)]);
disp(['Binary Image Distance: ' num2str(dbin)]);

% Plot ground truth
curvestrue{1}=betatrue{i};
plot_curves_on_image(curvestrue,exp(Sopt.I),Sopt.nrow,Sopt.scalefac,3,2,Sopt.cmax,'g');






