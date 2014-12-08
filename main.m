clear all
addpath(genpath('~/Softwares/ihog-master'))
addpath(genpath('~/Softwares/ihog-master/internal'))
addpath(genpath('~/Softwares/ihog-master/spams'))

%delete(gcp)
%parpool(6) % Change this to number of cores on your machine

global lambda_0  lambda_1  lambda_2  lambda;
global N K sqrtN;
global TrainingData;
global parent;


K = 6; % Number of classes
sqrtN=17;
N = sqrtN*sqrtN; % size of feature vectors

% Regularization parameters
lambda = 1;
lambda_0 = 1;
lambda_1 = 1;
lambda_2 = 1;

%LoadFineGrained();
%LoadTrainingDataWithHog();
%save('trainingFine', 'TrainingData');
temp=load('training.mat');
TrainingData2 = temp.TrainingData;
ReadTrainingData(TrainingData2);

theta = TreeMaker();
showAll(theta, TrainingData, parent);
testImageSet(theta)




