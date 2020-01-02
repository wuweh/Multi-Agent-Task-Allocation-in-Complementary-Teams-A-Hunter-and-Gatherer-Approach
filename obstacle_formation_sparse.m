%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [obstacles_map]=obstacle_formation_sparse(current_obstacles,n_obc_max)

if n_obc_max==0
    obstacles_map=current_obstacles;
else
    
    MAP=current_obstacles;
    [nrows,ncols]=size(MAP);
    n_obs=0;
    
    while n_obs < n_obc_max
        temp1=randi(nrows);
        temp2=randi(ncols);
        if MAP(temp1,temp2)== 0
            MAP(temp1,temp2)= -1;
            n_obs=n_obs+1;
        end
        obstacles_map=MAP;
    end
end