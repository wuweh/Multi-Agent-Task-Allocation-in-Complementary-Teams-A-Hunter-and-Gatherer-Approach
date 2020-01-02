%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [target_id] = target_give_id (target,n_total_trg,target_x,target_y)

for idd=1:n_total_trg
    if (target(idd).coordinate(1)==target_x)&&(target(idd).coordinate(2)==target_y)
        target_id=idd;
    end
end
end