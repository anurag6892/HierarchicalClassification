classdef CRP
    
    properties (Constant)
        lambda = 0.00001;
    end
    
   methods (Static)
      function prob = ProbabilityNew(numClass, ted)
         prob = log(CRP.lambda / (sum(ted,1)+CRP.lambda));
         disp(['the CRP for a new one and numClasses ', num2str(numClass), ' is ', num2str(prob)]);
      end
      function prob = Probability(j, numClass, ted)
         prob = log(ted(j) / (sum(ted,1)+CRP.lambda));
         disp(['the CRP for ' num2str(j), 'containing ', num2str(ted(j)),...
             ' classes and numClasses= ', num2str(numClass), ' is ', num2str(prob)]);

      end
      
   end
end

