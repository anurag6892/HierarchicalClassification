function [ parentUp, thetaUp, tedUp ] = makeNewTree(root, parent, theta, ted2) %TODO they don't go all under one supercatagory

global K ancestorsList;

parentUp = parent;
thetaUp = theta;
tedUp = ted2;

numSuperClass = 0;
ted = zeros(2*K+1,1);
ted2(root) = 0;

considering = [];
for i=1:K
    if(parent(i) == root)
        parent(i) = -1;
        considering = [considering; i];
    end
end


first = size(parent,1)+1;
all = size(considering, 1);
for c=1:size(considering,1)
    n = size(parent,1);
    i= considering(c);
    
    parent(i) = root;
    [lastThetaBest, ~, val] = findBestBeta(i, theta, parent, 1, root);
    likelihoodBest = -val + CRP.ProbabilityNew(all, ted);
    who = n+1;
    
    disp(['NEWWWW  likelihood of class ' , int2str(i), ' goes under a new supercatagory is', num2str(likelihoodBest)]);
    
    
    for j=first:n
        
        parent(i) = j;
        
        [lastTheta, ~, val] = findBestBeta(i, theta, parent, 0, root);
        
        likelihood = -val+ CRP.Probability(j, all, ted);%computeLikelihood(i, Beta) ;
        
        if likelihood > likelihoodBest
            
            who = j;
            
            likelihoodBest = likelihood;
            
            lastThetaBest = lastTheta;
            
        end
        
        disp(['NEWWW likelihood of class ' , int2str(i),...
            ' goes under supercatagory of ', num2str(j), 'is ', num2str(likelihood)]);
        
        
        
    end
    
    
    
    if(who==n+1)
        ted(who) = 1;
        ted2(who) = 1;
        parent(who) = root;
        theta(:,who) = lastThetaBest/2;
        lastThetaBest = lastThetaBest/2;
        numSuperClass = numSuperClass + 1;
    else
        ted(who) = ted(who) + 1;
        ted2(who) = ted2(who) + 1;
        
    end
    
    
    
    parent(i) = who;
    
    
    
    theta(:,i) = lastThetaBest;
    
    cprintf('cyan', ['NEWWWW parent of class ', int2str(i), ' became ', int2str(who), ' start optimizing whole tree' ]);
    
    ancestorsList = cell(size(parent,1),1);
    for j=1:size(parent,1)
        temp = [];
        child = j;
        while parent(child) ~= -1
            temp = [temp; parent(child)];
            child = parent(child);
        end
        ancestorsList{j} = temp;
    end
    
    theta = optimizeTree(theta, parent, K+1);
    
    % I assume that it will take care of new supercatagories and update
    
    % theta for this node and its parent.
    
    disp('NEWWW whole tree is optimized');
    
    
    
end

if(numSuperClass > 1)
    parentUp = parent;
    thetaUp = theta;
    tedUp = ted2;
end
% showAll(theta,TrainingData, parent);


end

