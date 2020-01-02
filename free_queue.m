%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [free] = free_queue (agent_g,agent_id)

free = 0;

for ii = 1:agent_g(agent_id).parameters(3)
    
    if agent_g(agent_id).queue (1,ii)==0
        free = ii ;
        break;
    end
    
end

clear ii
end