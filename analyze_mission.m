%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [agent,agent_g,results] = analyze_mission(agent,agent_g,n_gtr,n_htr,iteration,tt,results)


sum_hunted = 0;
sum_gathered = 0;
for idd=1:n_htr
    sum_hunted = sum_hunted + agent(idd).quantity;
end
clear idd

for idd=1:n_gtr
    sum_gathered = sum_gathered + agent_g(idd).quantity;
end
clear idd

% hunter
%************************************************************************************************
for idd=1:n_htr
    agent(idd).results = (iteration/agent(idd).cost(1))*(agent(idd).quantity);
    temp_h(idd)=agent(idd).results;
end
clear idd
%************************************************************************************************

% gatherer
%************************************************************************************************
for idd=1:n_gtr
    agent_g(idd).results = (iteration/agent_g(idd).cost(1))*(agent_g(idd).quantity);
    temp_g(idd)=agent_g(idd).results;
end
clear idd
%************************************************************************************************
sum_cost_h = 0;
sum_cost_g = 0;

for idd=1:n_htr
    sum_cost_h = sum_cost_h + agent(idd).cost(1);
end
clear idd
for idd=1:n_gtr
    sum_cost_g = sum_cost_g + agent_g(idd).cost(1);
end
clear idd
eff_t = (       1- (sum_cost_g +0.2*sum_cost_h)/((0.2*n_htr+n_gtr)*iteration)       )*sum_gathered;
eff_t_n = (       1- (sum_cost_g +0.2*sum_cost_h)/((0.2*n_htr+n_gtr)*iteration)       )*power(sum_gathered,1.5);
%**************************************************************************************************
results(tt).eff_h = [temp_h];
results(tt).eff_g = [temp_g];
results(tt).eff_t = [eff_t];
results(tt).n_gathered = [sum_gathered];
results(tt).n_hunted = [sum_hunted];
results(tt).cost_g = [sum_cost_g];
results(tt).cost_h = [sum_cost_h];
results(tt).eff_t_n = [eff_t_n];
%************************************************************************************************

end