function [updatedTheta] = optimizeTree(theta, parents)
% Do it for a two-level hierarchy and then extend it to a higher level
% hierarchy
global K;
updatedTheta = theta;
options = optimoptions(@fminunc,'GradObj','on', 'Display','off', 'Algorithm','quasi-newton');

epsilon = 0.1;
converged = 0;
count = 0;
prev_value = 10000;

while converged ~=1 % or fixed number of iterations( 3 ? :P :P)
    count = count +1;
    %optimize theta 0
    updatedTheta(:,K+1) = fminunc(@theta0_obj1, updatedTheta(:,K+1), options);
    updated_value = theta0_obj1(updatedTheta(:,K+1));
    %optimize theta 1
    for i =K+1:size(parents)
        if(parents(i) == -1)
            continue
        end
        if(parents(i) == K+1) %super class
            updatedTheta(:,i) = fminunc(@(theta1) theta1_obj1(theta1,i),updatedTheta(:,i), options);
            updated_value = updated_value + theta1_obj1(updatedTheta(:,i),i);
        end
    end
    
    %optimize theta 2
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
            ancestors = [];
            child = leafClass;
            while parents(child) ~= -1
                ancestors = [ancestors; parents(child)];
                child = parents(child);
            end
            %assert(size(ancestors,1) ~= 0, 'Ancestors is empty');
            ancestors = ancestors(ancestors ~= K + 1); % Remove root node
            
            beta = sum(updatedTheta(:,ancestors),2) + updatedTheta(:,leafClass);
            
            obj = obj + sum(log(1 + exp( (-1)*(beta + theta0)'*TrainingData{leafClass}.positive)));
            grad = grad - TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta0)'*TrainingData{leafClass}.positive )))');
            
            obj = obj + sum(log(1 + exp( (beta + theta0)'*TrainingData{leafClass}.negative)));
            grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta0)'*TrainingData{leafClass}.negative )))'), 2);
            
        end
        temp = 1/2*lambda*(norm(theta0)^2);
        obj = obj + temp;
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
            ancestors = [];
            child = leafClass;
            while parents(child) ~= -1
                ancestors = [ancestors; parents(child)];
                child = parents(child);
            end
            %assert(size(ancestors,1) ~= 0, 'Ancestors is empty');
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
        ancestors = [];
        child = leafClass;
        while parents(child) ~= -1
            ancestors = [ancestors; parents(child)];
            child = parents(child);
        end
        %assert(size(ancestors,1) ~= 0, 'Ancestors is empty');
        beta = sum(updatedTheta(:,ancestors),2);
        
        obj = obj + sum(log(1 + exp( (-1)*(beta + theta2)'*TrainingData{leafClass}.positive)));
        grad = grad - sum( TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta2)'*TrainingData{leafClass}.positive )))'), 2);
        
        obj = obj + sum(log(1 + exp( (beta + theta2)'*TrainingData{leafClass}.negative)));
        grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta2)'*TrainingData{leafClass}.negative )))'), 2);
        
        obj = obj + 1/2*lambda*(norm(theta2)^2);
        grad = grad + lambda*theta2;
    end

end
