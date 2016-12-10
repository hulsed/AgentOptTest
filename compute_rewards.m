 function [rewards] = compute_rewards(useD, ...
    x1,x2,var1,var2, func)
    % I included the material in the inputs because I didn't know how to
    % compute the counterfactual rod otherwise... -B
    
    % Global System Performance
    G = func(x1,x2);
    
    %ostensibly this is also where we calculate constraint penalties.
    
    if ~useD % if NOT using difference reward
        rewards = ones(2, 1) * G; % Just return G for all rewards
    else
        rewards = zeros(2, 1);
        
        % Create "average" components (moved this from main)
        avgx1=mean(var1);
        avgx2=mean(var2);
        
        for ag = 1:2
            switch ag
                case 1 
                    Gc1=func(avgx1,x2);
                    rewards(ag, 1) = G - Gc1;
                case 2 % replace sConfigs with 2
                    Gc2=func(x1,avgx2);
                    rewards(ag, 1) = G - Gc2 ;
            end
        end   
    end
    
%     for i = 1:14
%         if rewards(i) > 1000
%             rewards(i) = 1000;
%         end
%     end
end
