function [] = showTheta( x, theta )
imshow(im2double(reshape(theta(:,x),[9,9])), [min(theta(:,1)), max(theta(:,1))])
end

