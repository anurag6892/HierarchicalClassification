function [theta] = TreeMaker()
    
    global lambda_0 N K;
    global ancestorsList;
    global parent;
    Inf = 1000000;
    MaxChild = 4;
    parent = repmat([-1], K,1);
    theta = zeros(N, 2*K+1); % This should be 2*K + 1 
    ted = zeros(2*K+1,1); 
    root = false(K);
    
    theta(:, K+1) = mvnrnd(zeros(1, N), lambda_0*eye(N)); 
    parent(K+1) = -1;   % This is theta_0
    root(K+1) = true;
    
    
    %right now we assume the first K element in parent and theta are the
    %leaf and corrosponding to the classes.
    
    
    for i=1:K
        new = false;
        who = -1;
    likelihoodBest = -Inf;
    lastThetaBest = -1;
    n = size(parent,1);
        for j=K+1:n   %making new supercatagory under root j for this node.
            if root(j)
                parent(i) = j;
                [lastTheta, ~, val] = findBestBeta(i, theta, parent, 1,K+1);
                likelihood = -val + CRP.ProbabilityNew(10*K,ted); %computeLikelihood(i, Beta) +
                disp(['likelihood of class ' , int2str(i),...
                    ' goes under a new supercatagory of root', num2str(j),...
                    ' is ', num2str(likelihood)]);
                
                if(likelihood > likelihoodBest)
                    likelihoodBest = likelihood;
                    lastThetaBest = lastTheta;
                    who = j;
                    new = true;                    
                end
            end
        end
        
        for j=K+1:n
            if(~root(j))    %for all supercatagoris
                parent(i) = j;
                [lastTheta, ~, val] = findBestBeta(i, theta, parent, 0, K+1);
                likelihood = -val+ CRP.Probability(j, 10*K,ted);%computeLikelihood(i, Beta) ;
                if likelihood > likelihoodBest
                    who = j;
                    likelihoodBest = likelihood;
                    lastThetaBest = lastTheta;
                    new = false;
                end
                disp(['likelihood of class ' , int2str(i),...
                    ' goes under supercatagory of ', num2str(j), ' is ', num2str(likelihood), ' ', num2str(who)]);
                
                
            end

        end
        
        if(new)
            x = n + 1;
            parent(i) = x;
            theta(:,i) = lastThetaBest/2;
            parent(x) = who;
            theta(:,x) = lastThetaBest/2;
            ted(x) = 1;
            cprintf('cyan', ['parent of class ', int2str(i), ' became ',...
                int2str(x),' under ', num2str(who), ' start optimizing whole tree' ]);

        else
            parent(i) = who;
            theta(:,i) = lastThetaBest;            
            ted(who) = ted(who) + 1;
            cprintf('cyan', ['parent of class ', int2str(i), ' became ',...
                int2str(who), ' start optimizing whole tree' ]);
            if(ted(who) > MaxChild)
                
                 cprintf('red', ['starting make node ' num2str(who), ' a root.']);
                [parent, theta, ted, change]=makeNewTree(who, parent, theta, ted);
                if(change)
                    root(who)=true;
                    ted(who)=0;
                end
            end

        end
        
        
        
        ancestorsList = cell(size(parent,1),1);
        for j=1:size(parent)
            temp = [];
            child = j;
            while parent(child) ~= -1
                temp = [temp; parent(child)];
                child = parent(child);
            end
            ancestorsList{j} = temp;
        end
        
        % I assume that it will take care of new supercatagories and update
        % theta for this node and its parent.
        theta = optimizeTree(theta, parent, K+1);      
        disp('whole tree is optimized');      
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




