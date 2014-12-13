function class = testImage(input, theta)
    global ancestorsList K;
    bestProb = -10000;
    for leafClass=1:K
        ancestors = ancestorsList{leafClass};            
        beta = theta(:,leafClass) + sum(theta(:,ancestors),2);
        curProb = (1/(1 + exp(-beta'*input))) / (log(norm(beta)^2));
        %curProb = beta'*input/(norm(beta)^2);
        if (curProb > bestProb)
           bestProb = curProb;
           class = leafClass;
        end
    end
end

