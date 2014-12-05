function [updatedTheta] = optimizeTree(theta, parents)
global K ancestorsList;

epsilon = 0.1;
converged = 0;
count = 0;
prev_value = 10000;
options = optimoptions(@fminunc,'GradObj','on', 'Display','off', 'Algorithm','quasi-newton');

updatedTheta = theta;

while converged ~=1 
    %optimize theta of root node
    updatedTheta(:,K+1) = fminunc(@theta0_obj1, updatedTheta(:,K+1), options);
    updated_value = theta0_obj1(updatedTheta(:,K+1));
    
    %optimize theta of super class(interior) nodes
    for i=K+2:size(parents)
        updatedTheta(:,i) = fminunc(@(theta1) theta1_obj1(theta1,i),updatedTheta(:,i), options);
        updated_value = updated_value + theta1_obj1(updatedTheta(:,i),i);
    end
    
    %optimize theta leaf nodes
    for i =1:K
        if(parents(i) == -1)
            continue
        end      
        updatedTheta(:,i) = fminunc(@(theta2) theta2_obj1(theta2,i),updatedTheta(:,i), options);
        updated_value = updated_value + theta2_obj1(updatedTheta(:,i),i);
    end
    
    difference = updated_value - prev_value;
    
    if(abs(difference) < epsilon)
        converged = 1;
    end
        
    prev_value = updated_value;

end


    function [obj,grad] = theta0_obj1(theta0)
        global TrainingData;
        global lambda;
        obj = 0;
        grad = 0;
        for leafClass=1:K
            if(parents(leafClass) == -1)
                continue
            end
            ancestors = ancestorsList{leafClass};
            ancestors = ancestors(ancestors ~= K + 1); % Remove root node
            
            beta = sum(updatedTheta(:,ancestors),2) + updatedTheta(:,leafClass);
            
            obj = obj + sum(log(1 + exp( (-1)*(beta + theta0)'*TrainingData{leafClass}.positive)));
            grad = grad - TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta0)'*TrainingData{leafClass}.positive )))');
            
            obj = obj + sum(log(1 + exp( (beta + theta0)'*TrainingData{leafClass}.negative)));
            grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta0)'*TrainingData{leafClass}.negative )))'), 2);
            
        end
        obj = obj +  1/2*lambda*(norm(theta0)^2);
        grad = grad + lambda*theta0;
    end

    function [obj,grad] = theta1_obj1(theta1, superClass)
        global TrainingData;
        global lambda;
        obj = 0;
        grad = 0;
        for leafClass =1:K
            if(parents(leafClass) == -1)
                continue
            end
            ancestors = ancestorsList{leafClass};
            
            if sum(ancestors == superClass) == 0
                continue
            end
            ancestors = ancestors(ancestors ~= superClass);
            
            beta = sum(updatedTheta(:,ancestors),2) + updatedTheta(:,leafClass);
            
            obj = obj + sum(log(1 + exp( (-1)*(beta + theta1)'*TrainingData{leafClass}.positive)));
            grad = grad - sum( TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta1)'*TrainingData{leafClass}.positive )))'), 2);
            
            obj = obj + sum(log(1 + exp( (beta + theta1)'*TrainingData{leafClass}.negative)));
            grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta1)'*TrainingData{leafClass}.negative )))'), 2);
            
        end
        obj = obj + 1/2*lambda*(norm(theta1)^2);
        grad = grad + lambda*theta1;
    end

    function [obj,grad] = theta2_obj1(theta2, leafClass)
        global TrainingData;
        global lambda;
        obj = 0;
        grad = 0;
        
        ancestors = ancestorsList{leafClass};
        beta = sum(updatedTheta(:,ancestors),2);
        
        obj = obj + sum(log(1 + exp( (-1)*(beta + theta2)'*TrainingData{leafClass}.positive)));
        grad = grad - sum( TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta2)'*TrainingData{leafClass}.positive )))'), 2);
        
        obj = obj + sum(log(1 + exp( (beta + theta2)'*TrainingData{leafClass}.negative)));
        grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta2)'*TrainingData{leafClass}.negative )))'), 2);
        
        obj = obj + 1/2*lambda*(norm(theta2)^2);
        grad = grad + lambda*theta2;
    end

end
