%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [map_explored,no_pass,n_explored,agent,agent_g,target,map_timer,n_total_trg,map_actual]= explore_agent_g(map_actual,map_explored,n_explored,no_pass,agent_id,x,y,r,agent,agent_g,target,counter,map_timer,n_trg_current,action,n_total_trg)

[nrows, ncols] = size(map_actual);


% The variable revealed_time indicates the number of iterations before an
% explored cell becomes unexplored again. This is necessary to have a
% perpetual simulation and as symmetric as posssible condition as time
% passes.

revealed_time = 500;

xx=x;
yy=y;
[map_view , map_frontier , no_pass , map_view_notblocked] = fov_circular (xx,yy,map_actual,no_pass,r);

for ii=-r:1:r
    for jj=-r:1:r
        
        if inbound(xx+ii,yy+jj,nrows,ncols) && (distance(xx+ii,yy+jj,xx,yy)<r)
            
            map_explored(xx + ii , yy + jj) = map_actual(xx + ii , yy + jj);
            map_timer(xx+ii,yy+jj)=revealed_time;
            
            n_explored=n_explored+1;
            
            if (agent_g(agent_id).status(1) == 0)&&(agent_g(agent_id).status(2)~=0)
                if (xx + ii==agent_g(agent_id).queue(3,action))&&(yy + jj==agent_g(agent_id).queue(4,action))&&(target(agent_g(agent_id).queue(5,action)).status~=2)
                    
                    target(agent_g(agent_id).queue(5,action)).cost(2) = agent_g(agent_id).cost(2);
                    target(agent_g(agent_id).queue(5,action)).time(2) = counter;
                    agent_g(agent_id).cost(2)=0;
                    target(agent_g(agent_id).queue(5,action)).status = 2;
                    agent_g(agent_id).profit = agent_g(agent_id).profit + agent_g(agent_id).queue(2,action);
                    agent_g(agent_id).queue(:,action) = 0*agent_g(agent_id).queue(:,action);
                    agent_g(agent_id).status(2) = agent_g(agent_id).status(2)-1;
                    
                    map_actual (xx + ii,yy + jj) = 0;
                    [map_actual,target,n_total_trg]= target_birth(map_actual,n_total_trg,map_explored,target);
                    
                end
            end
            
        end
        
        if inbound(xx+ii,yy+jj,nrows,ncols)&& map_actual(xx + ii , yy + jj) ~=0
            
            no_pass(xx + ii , yy + jj)=true;
        end
        
        if inbound(xx+ii,yy+jj,nrows,ncols) && (distance(xx+ii,yy+jj,xx,yy)<=r+1)&& (distance(xx+ii,yy+jj,xx,yy)>=r) && (map_actual(xx + ii , yy + jj)==0) && (map_explored(xx + ii , yy + jj)==1)
            
            map_explored(xx + ii , yy + jj)=3;
            map_timer(xx+ii,yy+jj)=revealed_time;
        end
        
    end
end

end

