% Using the rewards received by each agent, update their Q-tables

% INPUTS
% agents - cell array of Q-tables, one for each agent
% rewards - vector of rewards, element i is the reward received by agent i
% actions - vector of integers, element i is the action taken by agent i
% alpha - the learning rate, 0 < alpha <= 1

% OUTPUTS
% The agents with updated Q-tables
function agents = update_values(agents, rewards, actions, alpha,learnmode)
    % Iterate through agents
    for ag = 1:numel(agents)
        % Get the current value of the action that agent ag took
        Va = agents{ag}(actions(ag));
        % Update the value of the action
        switch learnmode
            case 'best'
        agents{ag}(actions(ag)) = max(rewards(ag), Va);
            case 'rl'
        agents{ag}(actions(ag)) = Va + alpha*(rewards(ag) - Va);
        end
        
    end
end