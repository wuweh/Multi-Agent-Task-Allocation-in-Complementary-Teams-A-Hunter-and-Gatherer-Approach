%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [targets_map,target,n_total_trg]= target_distribution(current_targets,n_trg_max)

% generating the structures for targets
%**********************************************************************************************************
for idd=1:n_trg_max
    target(idd).id = 0;                         % traget's id
    target(idd).coordinate = [0 0];             % target's coordinate
    target(idd).status = 0;                     % 0:not detected, 1:detected (hunted), 2:gathered
    target(idd).by = [0 0];                     % target's hunter and gathere id
    target(idd).cost = [0 0];                   % the cost paid for hunting and gatherign the target
    target(idd).time = [inf inf];               % time of hunting and gathering
    target(idd).share_results = [0 0];          % the share of target's hunter and gatherer from Iex
    target(idd).share_method = [0 0];           % if bar: [1 stage] if auction: [2 number of bidders]
end
clear idd
%**********************************************************************************************************

% assigning id for each tagret
%***********************************************************************************************************
MAP=current_targets;
[MAX_X,MAX_Y]=size(MAP);
n_trg=0;
while n_trg < n_trg_max
    temp1=randi(MAX_X);
    temp2=randi(MAX_Y);
    if MAP(temp1,temp2)== 0
        MAP(temp1,temp2)= -2;
        n_trg=n_trg+1;
        target(n_trg).id=n_trg;
        target(n_trg).coordinate= [temp1 temp2];
    end
    targets_map=MAP;
end
n_total_trg = n_trg_max;
%************************************************************************************************************

end
