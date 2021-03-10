clear;
close all;
clc;


% Form training algorithm options structure array, Strain
Strain.filename='training_data.mat';
Strain.idxtrain=1:3;
Strain.options=optimoptions('fminunc','display','off','algorithm','quasi-newton');
Strain.backtracking=true;
Strain.register=true;
Strain.delta0=1;
Strain.deltamin=10^-5;
Strain.tol=10^-4;
Strain.maxit=50;
Strain.plotevol=true;
Strain.verbose=false;

% Compute the Sprior structure array containing prior model parameters 
% obtained from training data and options provided in Strain
Sprior=compute_prior_params(Strain);

% Save results for future use
save('prior.mat','Sprior');

% Plot training results
plotTraining(Sprior);