%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [agent] = read_inbox_id_h(agent_id,agent,n_gtr)
agent(agent_id).temp = zeros(1,agent(agent_id).inbox_number);

n_read=1;
for idd=1:n_gtr
    if agent(agent_id).inbox_id(idd)~=0
        agent(agent_id).temp(n_read) = agent(agent_id).inbox_id(idd);
        n_read=n_read+1;
    end
    if n_read==agent(agent_id).inbox_number+1
        break
    end
end
end