%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748

function [winner_id,winner_bid,acc_flag] = choose_winner(agent_id,agent,Iex,Ih,cost,alpha,beta,n_gtr)

winner_bid = 0;
winner_id = 0;
acc_flag = 0;

[a,b] = max_bid(agent_id,agent,n_gtr);

if (agent(agent_id).inbox_id(b)~=0)&& ( beta*a + alpha*Ih - cost > 0 )
    winner_bid = a;
    winner_id = b;
    acc_flag = 1;
end

end