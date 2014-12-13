% function [] = LoadFineGrained()
% global TrainingData N sqrtN;
% global TestingData;
%
%
% load('train_annos.mat');
%
% index = ones(569,1);
% startOfCars = 10818;
% startofCarsClass = 184;
%
% for i=startOfCars:startOfCars + 20 %   size(annotations, 2)
%     cur = annotations(i);
%     i
%      if (exist(cur.rel_path,'file') ~= 2)
%          disp('file does not exist!!!!');
%          cur.rel_path
%          continue
%      end
%      im=imread(cur.rel_path);
%      if size(im,3)==3
%             im = rgb2gray(im);
%      end
%      current = cur.class - startofCarsClass + 1;
%      TrainingData{current}.positive(:,index(current)) = double(extractHOGFeatures(...
%             imresize(im2double(im),[30,30])));
%      TrainingData{current}.real{index(current)} = imresize(im2double(im),[30,30]);
%
%      index(current) = index(current) + 1;
% end
%
% disp('reading all datas');
% size(TrainingData)
%
% index = ones(569,1);
%
%
% % for i=1:
% %     while index(i) <=size(TrainingData{i}.positive,2)
% %     j = floor(rand*size(annotations,2)) + 1;
% %     cur = annotations(j);
% %     if ((cur.domain_index ~= 3) && (exist(cur.rel_path,'file') == 2))
% %      im=imread(cur.rel_path);
% %      if size(im,3)==3
% %             im = rgb2gray(im);
% %      end
% %      TrainingData{i}.negative(:,index(i)) = double(extractHOGFeatures(...
% %             imresize(im2double(im),[30,30])));
% %      index(i) = index(i) + 1;
% %     end
% %     end
% % end
%
% N=size(TrainingData{1}.positive(:,1),1);
% sqrtN = sqrt(N);
%
%
%
%
%
% end



function [] = LoadFineGrained()
global TrainingData N sqrtN;
global TestingData;


load('train_annos.mat');

index = ones(569,1);

for i=10818:18962
    cur = annotations(i);
    if (cur.class >=184 && cur.class < 204)
        if (exist(cur.rel_path,'file') ~= 2)
            continue
        end
        im=imread(cur.rel_path);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        current = cur.class - 184 + 1;
        TrainingData{current}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        TrainingData{current}.class = cur.class;
        
        TrainingData{current}.real{index(cur.class)} = imresize(im2double(im),[30,30]);
        index(cur.class) = index(cur.class) + 1;
    end
end


disp('cars done');
car_class = size(TrainingData,2)


for i=18962:45541
    cur = annotations(i);
    if (cur.class >=380 && cur.class < 400)
        if (exist(cur.rel_path,'file') ~= 2)
            continue
        end
        im=imread(cur.rel_path);
        if size(im,3)==3
            im = rgb2gray(im);
        end
        rec = [cur.bbox.xmin, cur.bbox.ymin, cur.bbox.xmax - cur.bbox.xmin, cur.bbox.ymax - cur.bbox.ymin];
        im = imcrop(im, rec);
        TrainingData{car_class + cur.class-380+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
            imresize(im2double(im),[30,30])));
        TrainingData{car_class + cur.class-380+1}.class = cur.class;
        
        TrainingData{car_class + cur.class-380+1}.real{index(cur.class)} = imresize(im2double(im),[30,30]);
        index(cur.class) = index(cur.class) + 1;
    end
end

index = ones(569,1);
disp('dogs done');

for i=1:size(TrainingData, 2)
    while index(i) <= 2 * size(TrainingData{i}.positive,2)
        j = floor(rand*size(annotations,2)) + 1;
        cur = annotations(j);
        if ((cur.class ~= TrainingData{i}.class) && (exist(cur.rel_path,'file') == 2))
            im=imread(cur.rel_path);
            if size(im,3)==3
                im = rgb2gray(im);
            end
            rec = [cur.bbox.xmin, cur.bbox.ymin, cur.bbox.xmax - cur.bbox.xmin, cur.bbox.ymax - cur.bbox.ymin];
            im = imcrop(im, rec);
            TrainingData{i}.negative(:,index(i)) = double(extractHOGFeatures(...
                imresize(im2double(im),[30,30])));
            index(i) = index(i) + 1;
        end
    end
    i
end

disp('negative examples done');


% index = ones(569,1);

%
% for i=1:size(annotations,2)
%     cur = annotations(i);
%     if (cur.class >=184 && cur.class < 204)
%      if (exist(cur.rel_path,'file') ~= 2)
%          continue
%      end
%      im=imread(cur.rel_path);
%      if size(im,3)==3
%             im = rgb2gray(im);
%      end
%      TestingData{cur.class-184+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
%             imresize(im2double(im),[30,30])));
%      index(cur.class) = index(cur.class) + 1;
%     end
%
%     if (cur.class >=380 && cur.class < 400)
%      if (exist(cur.rel_path,'file') ~= 2)
%          continue
%      end
%      im=imread(cur.rel_path);
%      if size(im,3)==3
%             im = rgb2gray(im);
%      end
%      TestingData{car_class + cur.class-380+1}.positive(:,index(cur.class)) = double(extractHOGFeatures(...
%             imresize(im2double(im),[30,30])));
%      index(cur.class) = index(cur.class) + 1;
%     end
%
% end



end


