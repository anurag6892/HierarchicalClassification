clear all

% Change allocation size of parents, ted etc. becuase there will be more 
%   nodes with multi-level trees
% optimize tree assumes a clear separation of root node, interior node, and
%   leaf nodes 
 
global lambda_0  lambda_1  lambda_2  lambda;
global N K sqrtN;
global TrainingData;


K = 8; % Number of classes
sqrtN=17;
N = sqrtN*sqrtN; % size of feature vectors

% Regularization parameters
lambda = 1;
lambda_0 = 1;
lambda_1 = 1;
lambda_2 = 1;

% LoadTrainingData();
% save('training', 'TrainingData');
temp=load('training.mat');
TrainingData2 = temp.TrainingData;
ReadTrainingData(TrainingData2);
[parent, theta] = TreeMaker();
showAll(theta, TrainingData, parent);




