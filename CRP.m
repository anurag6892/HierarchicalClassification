classdef CRP
    
    properties (Constant)
        lambda = 0.001;
    end
    
   methods (Static)
      function prob = ProbabilityNew(ted)
         prob = log(CRP.lambda / (sum(ted,1)+CRP.lambda));
         disp(['the CRP for a new one is ', num2str(prob)]);
      end
      function prob = Probability(j, ted)
         prob = log(ted(j) / (sum(ted,1)+CRP.lambda));
         disp(['the CRP for ' num2str(j), ' containing ', num2str(ted(j)),...
             ' classes is ', num2str(prob)]);

      end
      
   end
end

