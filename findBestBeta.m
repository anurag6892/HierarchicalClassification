function [lastTheta, Beta, val] = findBestBeta(leafClass, theta, parents, new)
% Will optimize theta2 of class i while fixing everything else
global TrainingData lambda N;

ancestors = [];
child = leafClass;
while parents(child) ~= -1
    ancestors = [ancestors; parents(child)];
    child = parents(child);
end
%assert(size(ancestors,1) ~= 0, 'Ancestors is empty');
beta = sum(theta(:,ancestors),2);

    function [obj, grad] = theta2_obj(arg_theta)
        obj = 0;
        grad = 0;
        %for j = 1:size(TrainingData{leafClass}.positive)
        %    obj = obj + log(1 + exp( -1*(beta + arg_theta)'*TrainingData{leafClass}.positive{j}));
        %    grad = grad - (1/(1 + exp( (beta + arg_theta)'* TrainingData{leafClass}.positive{j})))*TrainingData{leafClass}.positive{j} ;
        %end
        obj = obj + sum(log(1 + exp( (-1)*(beta + arg_theta)'*TrainingData{leafClass}.positive)));
        grad = grad - TrainingData{leafClass}.positive*((1./(1 + exp( (beta + arg_theta)'*TrainingData{leafClass}.positive )))');
        %for j = 1:size(TrainingData{leafClass}.negative)
        %    obj = obj + log(1 + exp( 1*(beta + arg_theta)'*TrainingData{leafClass}.negative{j}));
        %    grad = grad + (1/(1 + exp( (-1)*(beta + arg_theta)'* TrainingData{leafClass}.negative{j})))*TrainingData{leafClass}.negative{j} ;
        %end
        obj = obj + sum(log(1 + exp( (beta + arg_theta)'*TrainingData{leafClass}.negative)));
        grad = grad + TrainingData{leafClass}.negative*((1./(1 + exp( (-1)*(beta + arg_theta)'*TrainingData{leafClass}.negative )))');
        
        if(new)
            obj = obj + 1/4*lambda*(norm(arg_theta)^2); % replace lambda2 by level specific lambda
            grad = grad + 1/2 * (arg_theta);
        else
            obj = obj + 1/2*lambda*(norm(arg_theta)^2); % replace lambda2 by level specific lambda
            grad = grad + lambda*(arg_theta);
        end
    end



init_theta = mvnrnd(zeros(1,N), lambda*ones(1,N))';

options = optimoptions(@fminunc,'GradObj','on', 'Display','off','Algorithm','quasi-newton');
[x,val,exitflag,output,grad,hessian] = fminunc(@theta2_obj, init_theta, options);
lastTheta = x;
Beta = beta + x;


    child = parents(leafClass);
    while child ~= -1
        val = val + 1/2*lambda*(norm(theta(child)^2));
        child = parents(child);
    end

end
