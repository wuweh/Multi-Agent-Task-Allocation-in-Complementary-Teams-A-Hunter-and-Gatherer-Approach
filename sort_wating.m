%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [sort_online,online_flag,n_online] = sort_wating (agent,n_htr)
% primary sorting
%**************************************************************************
n_online = 0;
n_sorted = 0;
online_flag = 0;
sort_online = 0;
for idd = 1:n_htr
    if (agent(idd).online(1)==2)
        n_online = n_online + 1;
        sort_temp (1,n_online) = idd;
        sort_temp (2,n_online) = 0;
        online_flag = 1;
    end
end
clear idd

%__________________________________________________________________________
if online_flag ==1
    time_min = inf;
    for idd_p = 1:n_online
        for idd=1:n_online
            if (agent(sort_temp (1,idd)).online(5)<time_min)&&(sort_temp(2,idd)==0)
                time_min = agent(sort_temp (1,idd)).online(5);
                iddd_min = idd;
            end
        end
        sort_online (idd_p) = sort_temp (1,iddd_min);
        sort_temp (2,iddd_min) = idd_p;
        time_min =inf;
    end
end
clear idd_p
clear idd
%__________________________________________________________________________
end