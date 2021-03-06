function [finalTheta] = optimizeTree(theta, parents, root)
global K ancestorsList;

PARancestorsList = ancestorsList;
PARK = K;

epsilon = 0.1;
converged = 0;
count = 0;
prev_value = 10000;
options = optimoptions(@fminunc,'GradObj','on', 'Display','off', 'Algorithm','quasi-newton');

updatedTheta = theta;
tempTheta = updatedTheta;

while (converged ~=1 )
    count = count + 1;
    
%     levels = zeros(size(parents,1),1);
%     for i=1:size(parents)
%         levels(i) = size(ancestorsList{i},1) + 1;
%     end
%     
%     maxlevels = max(levels);
%     levelNodes = cell(maxlevels,1);
%     for i=1:maxlevels
%        levelNodes{i} = []; 
%     end
%     
%     for i=1:size(levels)
%         levelNodes{levels(i)} =  [levelNodes{levels(i)}; i];
%     end
    
    %optimize theta of root node
    
    classList = [];
    betaList = [];
    for leafClass=1:K
            if(parents(leafClass) == -1)
                continue
            end
            ancestors = ancestorsList{leafClass};
            if sum(ancestors == root) == 0
                continue
            end
            
            ancestors = ancestors(ancestors ~= root);
            beta = sum(updatedTheta(:,ancestors),2) + updatedTheta(:,leafClass);
            classList = [classList; leafClass];
            betaList = [betaList beta];
    end
    
    updatedTheta(:,root) = fminunc(@(theta0) theta0_obj1(theta0, root,classList, betaList), updatedTheta(:,root), options);
    updated_value = theta0_obj1(updatedTheta(:,root),root,classList, betaList);
    
    if (0)
    for level=2:maxlevels
       curNodes = levelNodes{level}';
       
       for i = 1:size(parents,1)
           if find(curNodes == i) 
           if(parents(i) == -1)
                    continue
           end 
           ancestors = PARancestorsList{i};
           if sum(ancestors == root) == 0
                 continue
           end
           if i <= PARK      
               ancestors = PARancestorsList{i};
               beta = sum(updatedTheta(:,ancestors),2);
               tempTheta(:,i) = fminunc(@(theta2) theta2_obj1(theta2,i,beta), updatedTheta(:,i), options);
               updated_value = updated_value + theta2_obj1(tempTheta(:,i),i,beta);
           else
                 classList = [];
                 betaList = [];
                 for leafClass=1:PARK
                    if(parents(leafClass) == -1)
                        continue
                    end
                    ancestors = PARancestorsList{leafClass};
                 
                    if sum(ancestors == i) == 0
                        continue
                    end
            
                    ancestors = ancestors(ancestors ~= i);
            
                    beta = sum(updatedTheta(:,ancestors),2) + updatedTheta(:,leafClass);
                     
                    classList = [classList; leafClass];
                    betaList = [betaList beta];
                 end
               tempTheta(:,i) = fminunc(@(theta1) theta1_obj1(theta1,i,classList,betaList), updatedTheta(:,i), options);
               updated_value = updated_value + theta1_obj1(tempTheta(:,i),i,classList,betaList);
           end  
           else
              % disp('lol')
           end
       end
       updatedTheta = tempTheta;
    end
    
    else % if (root == K+1)
    
    %optimize theta of super class(interior) nodes
    for i=K+2:size(parents,1)
        ancestors = ancestorsList{i};     
        if sum(ancestors == root) == 0
                continue
        end
        
        classList = [];
        betaList = [];
        for leafClass=1:K
            if(parents(leafClass) == -1)
                continue
            end
            ancestors = ancestorsList{leafClass};
                 
            if sum(ancestors == i) == 0
                continue
            end
            
            ancestors = ancestors(ancestors ~= i);
            
            beta = sum(updatedTheta(:,ancestors),2) + updatedTheta(:,leafClass);
                     
            classList = [classList; leafClass];
            betaList = [betaList beta];
        end
        updatedTheta(:,i) = fminunc(@(theta1) theta1_obj1(theta1,i,classList,betaList),updatedTheta(:,i), options);
        updated_value = updated_value + theta1_obj1(updatedTheta(:,i),i,classList,betaList);
    end
    
    %optimize theta leaf nodes
    for i=1:K
        if(parents(i) == -1)
            continue
        end      
        ancestors = ancestorsList{i};
        if sum(ancestors == root) == 0
                continue
        end
        beta = sum(updatedTheta(:,ancestors),2);
        updatedTheta(:,i) = fminunc(@(theta2) theta2_obj1(theta2,i,beta),updatedTheta(:,i), options);
        updated_value = updated_value + theta2_obj1(updatedTheta(:,i),i,beta);
    end
    
    end % if (root == K+1)
    
    difference = updated_value - prev_value;
    
    if(abs(difference) < epsilon)
        converged = 1;
        count
    end
        
    prev_value = updated_value;

end
    finalTheta = updatedTheta;

end


 function [obj,grad] = theta0_obj1(theta0, root, classList, betaList)
        global TrainingData lambda K parent ancestorsList updatedTheta;
        obj = 0;
        grad = 0;
        for j=1:size(classList)
            leafClass = classList(j);
            beta = betaList(:,j);
            
            obj = obj + sum(log(1 + exp( (-1)*(beta + theta0)'*TrainingData{leafClass}.positive)));
            grad = grad - TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta0)'*TrainingData{leafClass}.positive )))');
            
            obj = obj + sum(log(1 + exp( (beta + theta0)'*TrainingData{leafClass}.negative)));
            grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta0)'*TrainingData{leafClass}.negative )))'), 2);
            
        end
        obj = obj +  1/2*lambda*(norm(theta0)^2);
        grad = grad + lambda*theta0;
 end
    
 
 function [obj,grad] = theta1_obj1(theta1, superClass, classList, betaList)
        global TrainingData lambda K parent ancestorsList updatedTheta;
        obj = 0;
        grad = 0;
        for j=1:size(classList)
            leafClass = classList(j);
            beta = betaList(:,j);
            
            obj = obj + sum(log(1 + exp( (-1)*(beta + theta1)'*TrainingData{leafClass}.positive)));
            grad = grad - sum( TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta1)'*TrainingData{leafClass}.positive )))'), 2);
            
            obj = obj + sum(log(1 + exp( (beta + theta1)'*TrainingData{leafClass}.negative)));
            grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta1)'*TrainingData{leafClass}.negative )))'), 2);
            
        end
        obj = obj + 1/2*lambda*(norm(theta1)^2);
        grad = grad + lambda*theta1;
    end

    function [obj,grad] = theta2_obj1(theta2, leafClass, beta)
        global TrainingData lambda;  %ancestorsList updatedTheta;
        obj = 0;
        grad = 0;
        
        %ancestors = ancestorsList{leafClass};            
        %beta = sum(updatedTheta(:,ancestors),2);
        
        obj = obj + sum(log(1 + exp( (-1)*(beta + theta2)'*TrainingData{leafClass}.positive)));
        grad = grad - sum( TrainingData{leafClass}.positive*((1./(1 + exp( (beta + theta2)'*TrainingData{leafClass}.positive )))'), 2);
        
        obj = obj + sum(log(1 + exp( (beta + theta2)'*TrainingData{leafClass}.negative)));
        grad = grad + sum( TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + theta2)'*TrainingData{leafClass}.negative )))'), 2);
        
        obj = obj + 1/2*lambda*(norm(theta2)^2);
        grad = grad + lambda*theta2;
    end

