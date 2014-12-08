function [ output_args ] = LoadFineGrained( input_args )
global TrainingData N sqrtN;
global TestingData;

fileID = fopen('~/Downloads/results/test_annos_track1.txt');
C = textscan(fileID,'%d %s %d %d %d %d %d','Delimiter',',');
fclose(fileID);

load('~/Downloads/results/test_annos_track1.mat')

numExamples = 600;
num = 1;
for i=11:30
    
    for index=0:numExamples-1
        rd = randi([11,30]);
        while rd == i
            rd =randi([11,30]);
        end
        suffix = '.jpg';
        if rd>=19
            suffix='.JPEG';
        end
        im=imread(['train_images/00',num2str(rd),'/FGCOMP_00',...
            num2str(rd*1000+randi([0,600])),suffix]);
        if size(im,3)==3
            TrainingData{num}.negative(:,index+1) = double(extractHOGFeatures(...
                imresize(im2double(rgb2gray(im)),[30,30])));
        else
            TrainingData{num}.negative(:,index+1) = double(extractHOGFeatures(...
                imresize(im2double(im),[30,30])));
        end
    end
    suffix = '.jpg';
    if i>=19
        suffix='.JPEG';
    end
    for index=0:numExamples-1
        im=imread(['train_images/00',num2str(i),'/FGCOMP_00',...
            num2str(i*1000+index),suffix]);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        TrainingData{num}.positive(:,index+1) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        TrainingData{num}.real{index+1} = imresize(im2double(im),[30,30]);
    end
    
    num = num + 1
    
end


N=size(TrainingData{1}.positive(:,1),1);
sqrtN = sqrt(N);
%Perm1 = randperm(length(TrainingData));
%TrainingData=TrainingData(Perm1);
save('traingingFineNotPerm.mat','TrainingData');
disp('training data is loaded');

num = 1;

for i=[11, 12, 15, 23, 26, 28]
    
    suffix = '.jpg';
    if i>=19
        suffix='.JPEG';
    end
    for index=0:numExamples-1
        if (i==15 && index >=480)  
            suffix='.JPEG';
        end
        if (exist(['test_images/00',num2str(i),'/FGCOMP_00',...
                num2str(i*1000+index),suffix], 'file') == 2)
          im=imread(['test_images/00',num2str(i),'/FGCOMP_00',...
            num2str(i*1000+index),suffix]);
          if size(im,3)==3
            im = rgb2gray(im);
          end
        
          TestingData{num}.positive(:,index+1) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
          TestingData{num}.real{index+1} = imresize(im2double(im),[30,30]);
        end
    end
    
    num = num + 1
    
end


end

