function class = testImage(input, theta)
    global ancestorsList K;
    bestProb = 0;
    for leafClass=1:K
        ancestors = ancestorsList{leafClass};            
        beta = sum(theta(:,ancestors),2) + theta(:,leafClass);
        curProb = 1/(1 + exp(-beta'*input));
        if (curProb > bestProb)
           bestProb = curProb;
           class = leafClass;
        end
    end
end

