classdef CRP
    
%         properties (Constant)
%             lambda = 0.001;
%         end
    
    methods (Static)
        function prob = ProbabilityNew(ted)
            if(sum(ted,1) == 0)
                prob = 1;
            else
                lambda = 0.001;%/sum(ted,1);
                prob = log(lambda / (sum(ted,1)+lambda));
            end
            disp(['the CRP for a new one is ', num2str(prob)]);
        end
        function prob = Probability(j, ted)
            lambda = 0.001;%/sum(ted,1);
            prob = log(ted(j) / (sum(ted,1)+lambda));
            disp(['the CRP for ' num2str(j), ' containing ', num2str(ted(j)),...
                ' classes is ', num2str(prob)]);
            
        end
        
    end
end

