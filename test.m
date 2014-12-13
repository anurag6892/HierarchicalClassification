function [] = test()
examples = rand(900,10);
beta = rand(900,1);

iterations = 0;
 
options = optimoptions(@fminunc,'GradObj','on');
[x,fval,exitflag,output,grad,hessian] = fminunc(@objective, rand(900,1), options);

exitflag
output

function [obj, grad]= objective(theta) 
        obj = 0;
        for j = 1:size(examples,2)
            obj = obj + log(1 + exp( (-1)^(mod(j,2))*(beta + theta)'*examples(:,j)));
        end
        obj = obj + 1/2*1*norm(theta);  
        
        grad = 0;
        for j = 1:size(examples,2)
          grad = grad - ((-1)^mod(j-1,2))*(1/(1 + exp( ((-1)^mod(j-1,2))*(beta + theta)'*examples(:,j))))*examples(:,j);
        end
        grad = grad + 1*theta;
        iterations = iterations + 1;
end
end