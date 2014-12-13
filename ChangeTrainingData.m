function [ TrainingDataUp ] = ChangeTrainingData( TrainingData )
    for i=1:8
        TrainingDataUp{i} = TrainingData{i};
    end
    for i=21:28
        TrainingDataUp{i-20 + 8} = TrainingData{i};
    end
    
end

