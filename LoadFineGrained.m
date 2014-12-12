function [ output_args ] = LoadFineGrained( input_args )
global TrainingData N sqrtN;
global TestingData;


load('train_annos.mat');

index = ones(569,1);
car_class = 20;

for i=1:size(annotations,2)
    cur = annotations(i);
    if (cur.class >=184 && cur.class < 204)
        if (exist(cur.rel_path,'file') ~= 2)
            continue
        end
        im=imread(cur.rel_path);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        a = cell2mat(struct2cell(annotations(i).bbox))';
        im  = imcrop(im,[a(1) a(3) a(2)-a(1) a(4)-a(3)]);
        
        TrainingData{cur.class-184+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        TrainingData{cur.class-184+1}.real{index(cur.class)} = imresize(im2double(im),[30,30]);
        index(cur.class) = index(cur.class) + 1;
    end
    
    if (cur.class >=380 && cur.class < 400)
        if (exist(cur.rel_path,'file') ~= 2)
            continue
        end
        im=imread(cur.rel_path);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        a = cell2mat(struct2cell(annotations(i).bbox))';
        im  = imcrop(im,[a(1) a(3) a(2)-a(1) a(4)-a(3)]);
        TrainingData{car_class + cur.class-380+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        TrainingData{car_class + cur.class-380+1}.real{index(cur.class)} = imresize(im2double(im),[30,30]);
        index(cur.class) = index(cur.class) + 1;
    end
    
end
index = ones(569,1);

disp('pos done')
for i=1:20
    while index(i) <=min(1000,10*size(TrainingData{i}.positive,2))
        j = floor(rand*size(annotations,2)) + 1;
        cur = annotations(j);
        if ((cur.domain_index == 3 || cur.domain_index == 4) && (cur.class ~= 184 + i-1) && (exist(cur.rel_path,'file') == 2))
            im=imread(cur.rel_path);
            if size(im,3)==3
                im = rgb2gray(im);
            end
            a = cell2mat(struct2cell(annotations(j).bbox))';
            im  = imcrop(im,[a(1) a(3) a(2)-a(1) a(4)-a(3)]);
            TrainingData{i}.negative(:,index(i)) = double(extractHOGFeatures(...
                imresize(im2double(im),[30,30])));
            index(i) = index(i) + 1;
        end
    end
end

disp('pos done 1')
for i=21:40
    while index(i) <=min(1000,10*size(TrainingData{i}.positive,2))
        j = floor(rand*size(annotations,2)) + 1;
        cur = annotations(j);
        if ((cur.domain_index == 3 || cur.domain_index == 4) && (cur.class ~= 380 + i-21) && (exist(cur.rel_path,'file') == 2))
            im=imread(cur.rel_path);
            if size(im,3)==3
                im = rgb2gray(im);
            end
            a = cell2mat(struct2cell(annotations(j).bbox))';
            im  = imcrop(im,[a(1) a(3) a(2)-a(1) a(4)-a(3)]);
            TrainingData{i}.negative(:,index(i)) = double(extractHOGFeatures(...
                imresize(im2double(im),[30,30])));
            
            index(i);
            index(i) = index(i) + 1;
        end
    end
    aa=index(i);
    bb=i;
end

disp('pos done 2')

load('train_annos.mat')

index = ones(569,1);


for i=1:size(annotations,2)
    cur = annotations(i);
    if (cur.class >=184 && cur.class < 204)
        if (exist(cur.rel_path,'file') ~= 2)
            continue
        end
        im=imread(cur.rel_path);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        a = cell2mat(struct2cell(annotations(i).bbox))';
        im  = imcrop(im,[a(1) a(3) a(2)-a(1) a(4)-a(3)]);
        
        TestingData{cur.class-184+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        index(cur.class) = index(cur.class) + 1;
    end
    
    if (cur.class >=380 && cur.class < 400)
        if (exist(cur.rel_path,'file') ~= 2)
            continue
        end
        im=imread(cur.rel_path);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        a = cell2mat(struct2cell(annotations(i).bbox))';
        im  = imcrop(im,[a(1) a(3) a(2)-a(1) a(4)-a(3)]);
        TestingData{car_class + cur.class-380+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        index(cur.class) = index(cur.class) + 1;
    end
    
end

disp('test done')

N=size(TrainingData{1}.positive(:,1),1);
sqrtN = sqrt(N);




% numExamples = 600;
% num = 1;
% for i=11:30
%
%     for index=0:numExamples-1
%         rd = randi([11,30]);
%         while rd == i
%             rd =randi([11,30]);
%         end
%         suffix = '.jpg';
%         if rd>=19
%             suffix='.JPEG';
%         end
%         im=imread(['train_images/00',num2str(rd),'/FGCOMP_00',...
%             num2str(rd*1000+randi([0,600])),suffix]);
%         if size(im,3)==3
%             TrainingData{num}.negative(:,index+1) = double(extractHOGFeatures(...
%                 imresize(im2double(rgb2gray(im)),[30,30])));
%         else
%             TrainingData{num}.negative(:,index+1) = double(extractHOGFeatures(...
%                 imresize(im2double(im),[30,30])));
%         end
%     end
%     suffix = '.jpg';
%     if i>=19
%         suffix='.JPEG';
%     end
%     for index=0:numExamples-1
%         im=imread(['train_images/00',num2str(i),'/FGCOMP_00',...
%             num2str(i*1000+index),suffix]);
%         if size(im,3)==3
%             im = rgb2gray(im);
%         end
%         TrainingData{num}.positive(:,index+1) = double(extractHOGFeatures(...
%             imresize(im2double(im),[30,30])));
%         TrainingData{num}.real{index+1} = imresize(im2double(im),[30,30]);
%     end
%
%     num = num + 1
%
% end
%
%
% N=size(TrainingData{1}.positive(:,1),1);
% sqrtN = sqrt(N);
% %Perm1 = randperm(length(TrainingData));
% %TrainingData=TrainingData(Perm1);
% save('traingingFineNotPerm.mat','TrainingData');
% disp('training data is loaded');
%
% num = 1;
%
% for i=[11, 12, 15, 23, 26, 28]
%
%     suffix = '.jpg';
%     if i>=19
%         suffix='.JPEG';
%     end
%     for index=0:numExamples-1
%         if (i==15 && index >=480)
%             suffix='.JPEG';
%         end
%         if (exist(['test_images/00',num2str(i),'/FGCOMP_00',...
%                 num2str(i*1000+index),suffix], 'file') == 2)
%           im=imread(['test_images/00',num2str(i),'/FGCOMP_00',...
%             num2str(i*1000+index),suffix]);
%           if size(im,3)==3
%             im = rgb2gray(im);
%           end
%
%           TestingData{num}.positive(:,index+1) = double(extractHOGFeatures(...
%             imresize(im2double(im),[30,30])));
%           TestingData{num}.real{index+1} = imresize(im2double(im),[30,30]);
%         end
%     end
%
%     num = num + 1
%
% end


end

