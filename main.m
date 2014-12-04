% Load all images
% delete(gcp)
% parpool(6);

% Things to do for making code work
% Things to do for optimizing code
% Allocate arrays statically and maintain a variable indicating the
%   array size(no. of non-zero or non-empty entries)
% Need not load all images at the start. Can load images on demand at
%   runtime. Images take a lot of space and storing all of them in program  
%   memory will consume a lot of unnecessary RAM
% Replace for loops with matrix operations >:P For this we need to store
% TrainingData{class}.positive as a matrix, not a cell. 
% Value of lambda. Depends on whether we are scaling images to 0-1 range or
%   not
% Sometimes optimize tree is getting stuck when called for the first time.
% This could be bcoz of the convergence condition used now. 



clear all
 
global lambda_0  lambda_1  lambda_2  lambda;
global N K sqrtN;
global TrainingData;


K = 9; % Number of classes
sqrtN=17;
N = sqrtN*sqrtN; % size of feature vectors

% Regularization parameters
lambda = 1;
lambda_0 = 1;
lambda_1 = 1;
lambda_2 = 1;

LoadTrainingData();
TrainingData


[parent, theta] = TreeMaker();
showAll(theta, TrainingData, parent);




