function [parent, theta] = TreeMaker()
    
   global TrainingData  lambda_0 lambda_1 N K;
    parent = repmat([-1], K,1);
    theta = zeros(N, 2*K+1); % This should be 2*K + 1 
    ted = zeros(2*K+1,1); 
    
    numSuperClass = 0;
    theta(:, K+1) = mvnrnd(zeros(1, N), lambda_0*eye(N)); 
    parent(K+1) = -1;   % This is theta_0
    root(K+1) = true;
    
    %right now we assume the first K element in parent and theta are the
    %leaf and corrosponding to the classes.
  
    for i=1:K
        
        
        parent(i) = K+1;% K + 1 + numSuperClass+1; %TODO: make a supercatagory
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
        
       % showAll(theta,TrainingData, parent);
        
        
    end
end

function [value] = computeLikelihood(class, beta)
    % for finding exact amount of p(betha) we should see all the theta but
    % right now I just use one lambda_2 (in the paper they said they set all
    % lambda to 1.
    global lambda_2 TrainingData N K sqrtN;
 
    p_beta = log(mvnpdf(beta', zeros(1,N), (1/lambda_2).*eye(N)));
    
    % I assumed y_i /in {1, -1}.
    
    % x = input of class, y = output of class I will correct the format of
    % input.
    
    x = TrainingData{class}.positive;
    
    % I should change it to matrix form instead of for !
    n = size(x,1);
    value = 0;
    value = value + sum(log(1./(1+exp(-beta'*x))));
    
    x = TrainingData{class}.negative;   
    % I should change it to matrix form instead of for !
    n = size(x,1);
    value = value + sum(log(1./(1+exp(beta'*x))));
    
    disp(['likelihood for beta is computed and the value is ', num2str(value), ' and p_beta is ',...
        num2str(p_beta)]);

    value = value + p_beta;
    
end




