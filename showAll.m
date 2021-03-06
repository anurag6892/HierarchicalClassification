function [  ] = showAll( theta, TrainingData, parent )

global K sqrtN;
n=size(theta,2);
m=K;
figure;

for i=1:m
    subplot_tight(6,m,i);
    imshow(im2double(TrainingData{i}.real{1}));
 %   title(num2str(i));
end

for i=1:m
    subplot_tight(6,m,m+i);
    imshow(im2double(TrainingData{i}.real{2}));
  %  title(num2str(i));
end

for i=1:m
    subplot_tight(6,m,2*m+i);
    imshow(im2double(TrainingData{i}.real{3}));
  %  title(num2str(i));
end

for i=1:m
    subplot_tight(6,m,3*m+i);
    imshow(im2double(TrainingData{i}.real{4}));
  %  title(num2str(i));
end
for i=1:m
    subplot_tight(6,m,4*m+i);
    imshow(im2double(TrainingData{i}.real{5}));
  %  title(num2str(i));
end
for i=1:m
    subplot_tight(6,m,5*m+i);
    imshow(im2double(TrainingData{i}.real{6}));
  %  title(num2str(i));
end

% for i=1:m
%     subplot(4,m,i);
%     imshow(im2double(reshape(TrainingData{i}.positive(:,1),[sqrtN,sqrtN])));
%     title(num2str(i));
% end


for i=1:m
    ancestors = [];
    child = i;
    while parent(child) ~= -1
        ancestors = [ancestors; parent(child)];
        child = parent(child);
    end
    beta(:,i) = sum(theta(:,ancestors),2);
end

% Min = min(min(beta(:)), min(theta(:)));
% Max = max(max(beta(:)), max(theta(:)));
% 
% for i=1:m  
%     subplot(4,m,m+i);
%     im = im2double(reshape(beta(:,i),[sqrtN,sqrtN]));
% %     im=repmat(im,[1,1,3])
% %     feat = features(im,1);
% %     ihog = invertHOG(feat);
%     imshow(im);
% end
% 
% 
% 
% for i=1:m
%     subplot(4,m,2*m+i);
%     imshow(im2double(reshape(theta(:,i),[sqrtN,sqrtN])));
%     
% end
% 
% for i=m+1:2*m
%     subplot(4,m,2*m+i);
%     imshow(im2double(reshape(theta(:,i),[sqrtN,sqrtN])));
%     
% end
% 
% figure;
% 
% % for i=1:m
% %     for j=1:m
% %     subplot(m,m,(i-1)*m+j);
% %     imshow(im2double(reshape(theta(:,i)+theta(:,j),[sqrtN,sqrtN])));
% %     end
% %     
% % end
% 
for i=1:size(parent)
    if parent(i) == -1
        parent(i) = 0;
    end
end
figure;
treeVec = parent';
treeplot(treeVec);
count = size(treeVec,2);
[x,y] = treelayout(treeVec);
x = x';
y = y';
name1 = cellstr(num2str((1:count)'));
text(x(:,1), y(:,1), name1, 'VerticalAlignment','bottom','HorizontalAlignment','right')
title({'Level Lines'},'FontSize',12,'FontName','Times New Roman');

