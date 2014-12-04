classdef CRP
    
    properties (Constant)
        lambda = 0.1;
    end
    
   methods (Static)
      function prob = ProbabilityNew(numClass)
         prob = log(CRP.lambda / (numClass+CRP.lambda));
         disp(['the CRP for a new one and numClasses ', num2str(numClass), ' is ', num2str(prob)]);
      end
      function prob = Probability(j, numClass, ted)
         prob = log(ted(j) / (numClass+CRP.lambda));
         disp(['the CRP for ' num2str(j), 'containing ', num2str(ted(j)),...
             ' classes and numClasses= ', num2str(numClass), ' is ', num2str(prob)]);

      end
      
   end
end

