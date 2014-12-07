function [ output_args ] = LoadFineGrained( input_args )
global TrainingData K N sqrtN;

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
Perm1 = randperm(length(TrainingData));
TrainingData=TrainingData(Perm1);
disp('training data is loaded');

end

