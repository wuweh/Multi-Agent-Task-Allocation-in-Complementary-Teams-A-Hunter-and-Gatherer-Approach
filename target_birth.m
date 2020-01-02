%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [targets_map,target,n_total_trg]= target_birth(current_targets,n_total_trg,map_explored,target)



% generating the structures for targets
%**********************************************************************************************************
n_total_trg = n_total_trg + 1;

target(n_total_trg).id = n_total_trg;               % traget's id
target(n_total_trg).coordinate = [0 0];             % target's coordinate
target(n_total_trg).status = 0;                     % 0:not detected, 1:detected (hunted), 2:gathered
target(n_total_trg).by = [0 0];                     % target's hunter and gathere id
target(n_total_trg).cost = [0 0];                   % the cost paid for hunting and gatherign the target
target(n_total_trg).time = [inf inf];               % time of hunting and gathering
target(n_total_trg).share_results = [0 0];          % the share of target's hunter and gatherer from Iex
target(n_total_trg).share_method = [0 0];           % if bar: [1 stage] if auction: [2 number of bidders]

%**********************************************************************************************************

% assigning id for the new tagret
%***********************************************************************************************************
MAP=current_targets;
[MAX_X,MAX_Y]=size(MAP);

gen_flag = 0;

while gen_flag ==0
    temp1=randi(MAX_X);
    temp2=randi(MAX_Y);
    if (MAP(temp1,temp2)== 0)&&(map_explored(temp1,temp2)==1)
        MAP(temp1,temp2)= -2;
        target(n_total_trg).coordinate= [temp1 temp2];
        gen_flag = 1;
    end
    targets_map=MAP;
end
%************************************************************************************************************
end