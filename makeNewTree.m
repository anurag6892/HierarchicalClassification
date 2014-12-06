function [ parentUpdated, thetaUpdated ] = makeNewTree(root, parent, theta) %TODO they don't go all under one supercatagory
global TrainingData  lambda_0 lambda_1 N K;


numSuperClass = 0;

for i=1:K
    considering = [];
    if(parent(i) == root)
        parent(i) = -1;
        considering = [considering; i];
    end
end

for i=1:size(considering,1)
        parent(i) = root;% K + 1 + numSuperClass+1; %TODO: make a supercatagory
        
        [lastThetaBest, Beta, val] = findBestBeta(i, theta, parent, 1);
        
        likelihoodBest = -val + CRP.ProbabilityNew(numSuperClass, ted); %computeLikelihood(i, Beta) +
        
        who = K + 2 + numSuperClass; %when this is the new we should also find theta_1
        
        
        
        disp(['likelihood of class ' , int2str(i), ' goes under a new supercatagory is', num2str(likelihoodBest)]);
        
        for j=K+2:K+1+numSuperClass
            
            parent(i) = j;
            
            [lastTheta, Beta, val] = findBestBeta(i, theta, parent, 0);
            
            likelihood = -val+ CRP.Probability(j, numSuperClass, ted);%computeLikelihood(i, Beta) ;
            
            if likelihood > likelihoodBest
                
                who = j;
                
                likelihoodBest = likelihood;
                
                lastThetaBest = lastTheta;
                
            end
            
            disp(['likelihood of class ' , int2str(i),...
                
            ' goes under supercatagory of ', num2str(j), 'is ', num2str(likelihood)]);
        
        
        
        end
        
        
        
        if(who==K+2+numSuperClass)
            
            parent(who) = K+1;
            
            theta(:,who) = lastThetaBest/2;
            
            numSuperClass = numSuperClass + 1;
            
            lastThetaBest = lastThetaBest/2;
            
        end
        
        
        
        parent(i) = who;
        
        ted(who) = ted(who) + 1;
        
        theta(:,i) = lastThetaBest;
        
        cprintf('cyan', ['parent of class ', int2str(i), ' became ', int2str(who), ' start optimizing whole tree' ]);
        
        
        
        theta = optimizeTree(theta, parent);
        
        % I assume that it will take care of new supercatagories and update
        
        % theta for this node and its parent.
        
        disp('whole tree is optimized');
    end
end



% showAll(theta,TrainingData, parent);


end

