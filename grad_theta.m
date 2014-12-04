function grad = grad_theta()
    global images lambda0;
     grad = 0;
     for face=1:3
        for nose=1:4
            for mouth=1:3
                for eye=1:3
                    for index=1:100
                    grad = grad - grad_loss(face, nose, mouth, eye, index)...
                        *images{face,nose,mouth,eye,index};
                    end
                end
            end
        end
     end
    grad = grad + lambda0*theta0;
end

function loss = grad_loss(face, nose, mouth, eye, index)
    global images theta0 theta1 theta2 theta3 theta4;
    loss = 1/(1 + exp( (theta0 + theta1(:,face) + theta2(:,nose) + theta3(:,mouth)...
        + theta4(:,eye))' * images{face,nose,mouth,eye,index} ));
end
