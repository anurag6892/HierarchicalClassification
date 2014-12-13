function [ output_args ] = LoadTrainingDataWithHog( input_args )

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
        for mouth=1:2
            for eye=1:2
                TrainingData{num}.name = dirs{face,nose,mouth,eye,type};
                TrainingData{num}.size = numExamples;
                for type=1:2 
                    for index=0:numExamples-1                          
                        if type == 2
                            TrainingData{num}.negative(:,index+1) = double(extractHOGFeatures(im2double(rgb2gray(imread(strcat('SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG'))))));
                        
                        else
                            TrainingData{num}.positive(:,index+1) = double(extractHOGFeatures(im2double(rgb2gray(imread(strcat('SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG'))))));
                        TrainingData{num}.real{index+1} = (im2double(rgb2gray(imread(strcat('SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))));
                        end

                    end
                end
                num = num + 1

            end
        end
    end
end

for face=1:2
    for nose=1:2
        for mouth=4:4
            for eye=4:4
                TrainingData{num}.name = dirs{face,nose,mouth,eye,type};
                TrainingData{num}.size = numExamples;
                for type=1:2 
                    for index=0:numExamples-1                          
                        if type == 2
                            TrainingData{num}.negative(:,index+1) = double(extractHOGFeatures(im2double(rgb2gray(imread(strcat('SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG'))))));
                        
                        else
                            TrainingData{num}.positive(:,index+1) = double(extractHOGFeatures(im2double(rgb2gray(imread(strcat('SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG'))))));
                        TrainingData{num}.real{index+1} = (im2double(rgb2gray(imread(strcat('SmilyFaces/feri2/',...
                            strrep(dirs{face,nose,mouth,eye,type},'''',''),...
                            int2str(index),'.PNG')))));
                        end

                    end
                end
                num = num + 1

            end
        end
    end
end

N=size(TrainingData{1}.positive(:,1),1);
sqrtN = sqrt(N);
Perm1 = randperm(length(TrainingData));
TrainingData=TrainingData(Perm1);
disp('training data is loaded');

end

