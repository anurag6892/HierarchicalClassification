function [] = LoadTrainingData()
    % Training data is an array of size k (which k corosponds to number of
    % classes). Each compoent  or the array is a cell. Each cell has a
    % name (name of the class), size of training examples and n training
    % examples. Each training example contiains input(x) which is an image
    % and ouput which is either +1, -1.
    
    % Right now for our specific training data there is no negative example
    % However, I can add manually or we can choose some negative example from
    % other classes (which make more sense :D)


global TrainingData K N sqrtN;

dirs = cell(4,5,4,4,2);

face_n = {'SQUARE', 'CIRCLE' ,'DASHED', 'NONE'};
nose_n = {'CIRCLE', 'LINE','SQUARE', 'NONE','OVAL'};
mouth_n = {'ANGRY', 'SAD' ,'SMILEY', 'NONE'};
eye_n = {'SQUARE', 'CROSS' ,'CIRCLE', 'NONE'};
pos_neg = {'positive' ,'negative'};

for face=1:4
    for nose=1:5
        for mouth=1:4
            for eye=1:4
                for type=1:2
                dirs{face,nose,mouth,eye,type} = strcat(mat2str(face_n{face}),'/',...
                    mat2str(nose_n{nose}),'/',mat2str(mouth_n{mouth}),'/',...
                    mat2str(eye_n{eye}),'/', mat2str(pos_neg{type}), '/');
                end
            end
        end
    end
end

num = 1;
TrainingData = cell(K, 1);
numExamples = 1000; %number of example


for face=4:4
    for nose=4:4
        for mouth=4:4
            for eye=1:4
                TrainingData{num}.name = dirs{face,nose,mouth,eye,type};
                TrainingData{num}.size = numExamples;
                for type=1:2 
                    for index=0:numExamples-1                          
                        if type == 2
                            TrainingData{num}.negative(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        
                        else
                            TrainingData{num}.positive(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        end

                    end
                end
                num = num + 1

            end
        end
    end
end


for face=4:4
    for nose=4:4
        for mouth=1:4
            for eye=4:4
                TrainingData{num}.name = dirs{face,nose,mouth,eye,type};
                TrainingData{num}.size = numExamples;
                for type=1:2 
                    for index=0:numExamples-1  
                        
                        if type == 2
                            TrainingData{num}.negative(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        else
                            TrainingData{num}.positive(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        end

                    end
                end
                num = num + 1;

            end
        end
    end
end

for face=4:4
    for nose=1:5
        for mouth=4:4
            for eye=4:4
                TrainingData{num}.name = dirs{face,nose,mouth,eye,type};
                TrainingData{num}.size = numExamples;
                for type=1:2 
                    for index=0:numExamples-1  
                        
                        if type == 2
                            TrainingData{num}.negative(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        else
                            TrainingData{num}.positive(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        end

                    end
                end
                num = num + 1;

            end
        end
    end
end

for face=1:4
    for nose=4:4
        for mouth=4:4
            for eye=4:4
                TrainingData{num}.name = dirs{face,nose,mouth,eye,type};
                TrainingData{num}.size = numExamples;
                for type=1:2 
                    for index=0:numExamples-1  
                        
                        if type == 2
                            TrainingData{num}.negative(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        else
                            TrainingData{num}.positive(:,index+1) = reshape(imresize(im2double(rgb2gray(imread(strcat('../SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))),[sqrtN,sqrtN]),N,1);
                        end

                    end
                end
                num = num + 1;

            end
        end
    end
end

Perm1 = randperm(length(TrainingData));
TrainingData=TrainingData(Perm1);
disp('training data is loaded');

end

% % N = size(images{1,1,1,1,1,1},1);
% % S = 10; % Number of super classes
% % num = 108; % Number of classes
% % 
% % trainingData = cell(num); % This will contain images or just pointers to images in 'images' cell. 
% % 
% % % Learned Parameters
% % theta = [];
% % 
% % % Regularization parameters
% % lambda = 1;
