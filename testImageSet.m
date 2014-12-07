function accuracy = testImageSet(theta)
    global TestingData TrainingData;
    TestingData = TrainingData;
    totalExamples = 0;
    correctExamples = 0;
    for i=1:size(TestingData,1);
       for j=1:size(TestingData{i}.positive, 2)
        predictedClass = testImage(TestingData{i}.positive(:,j), theta);
        if (predictedClass == i)% TestingData{i}.class)
           correctExamples = correctExamples + 1;
        end
        totalExamples = totalExamples + 1;
       end
       
       for j=1:size(TestingData{i}.negative, 2)
        predictedClass = testImage(TestingData{i}.negative(:,j), theta);
        if (predictedClass ~= i)% TestingData{i}.class)
           correctExamples = correctExamples + 1;
        end
        totalExamples = totalExamples + 1;
       end
    end

    accuracy = (correctExamples/totalExamples)*100;
end