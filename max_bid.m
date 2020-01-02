%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [a,b] = max_bid (agent_id,agent,n_gtr)

[a,~] = max(agent(agent_id).inbox);
temp_set = zeros(1,n_gtr);
quant_max =0;
for idd = 1:n_gtr
    if agent(agent_id).inbox(idd) == a
        quant_max = quant_max +1;
        temp_set(quant_max) = idd;
    end
end
b=temp_set((randi(quant_max)));

end