function accuracy = testImageSet(theta)
    global TestingData TrainingData K;
    totalExamples = 0;
    correctExamples = 0;
    TestingData = TrainingData';
%     index = [11 12 15 23 26 28];
%     index = index - 10;
%     
%     for i=1:size(TestingData,1);
%        count = zeros(1,20);
%        for j=1:size(TestingData{i}.positive, 2)
%         predictedClass = testImage(TestingData{i}.positive(:,j), theta);
%         count(predictedClass) = count(predictedClass) + 1;
%         if (predictedClass == index(i))
%            correctExamples = correctExamples + 1;
%         end
%         totalExamples = totalExamples + 1;
%        end
%        count
%     end
temp =0;
for i=1:K
    count = zeros(1,K);
    for j=1:size(TestingData{i}.test, 2)
        predictedClass = testImage(TestingData{i}.test(:,j), theta);
        count(predictedClass) = count(predictedClass) + 1;
%         if (floor((predictedClass-1)/20) == floor((i-1)/20))
%             correctExamples = correctExamples + 1;
%         end
        totalExamples = totalExamples + 1;
        if(predictedClass == i)
            correctExamples = correctExamples + 1;
        end
    end
    [a,pos] = max(count);
    if (pos == i)
        temp = temp + 1;
    end
    count
end

temp
correctExamples
totalExamples
accuracy = (correctExamples/totalExamples)*100
accuracy2 = (temp/K)*100

end
