function accuracy = testImageSet(theta)
    global TestingData;
    totalExamples = 0;
    correctExamples = 0;
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
   for i=1:size(TestingData,2)
       count = zeros(1,40);
       for j=1:size(TestingData{i}.positive, 2)
        predictedClass = testImage(TestingData{i}.positive(:,j), theta);
        count(predictedClass) = count(predictedClass) + 1;
        if (floor((predictedClass-1)/20) == floor((i-1)/20))
           correctExamples = correctExamples + 1;
        end
        totalExamples = totalExamples + 1;
       end
       count;
       [a,pos] = max(count)
       if (pos == i) 
           temp = temp + 1;
       end
    end

    temp
    correctExamples
    totalExamples
    accuracy = (correctExamples/totalExamples)*100;
end
