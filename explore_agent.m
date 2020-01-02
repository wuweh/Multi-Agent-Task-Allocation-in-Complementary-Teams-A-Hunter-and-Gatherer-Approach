%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [map_explored,no_pass,n_explored,new_ii,new_jj,agent,target,map_timer,n_total_trg]= explore_agent(map_actual,map_explored,n_explored,no_pass,agent_id,agent,target,n_trg,r,counter,map_timer,Ih,n_total_trg)

xx=agent(agent_id).coordinate(1);
yy=agent(agent_id).coordinate(2);
revealed_time = 500;
[nrows, ncols] = size(map_actual);

[map_view , map_frontier , no_pass , map_view_notblocked] = fov_circular (xx,yy,map_actual,no_pass,r);

for ii=-r-1:1:r+1
    
    for jj=-r-1:1:r+1
        
        if inbound(xx+ii,yy+jj,nrows,ncols) &&  (map_view_notblocked(xx+ii,yy+jj)==true )
            map_explored(xx+ii,yy+jj)= map_actual(xx+ii,yy+jj);
            map_timer(xx+ii,yy+jj)=revealed_time;
            
            
            if (map_actual(xx + ii , yy + jj) ==-2)
                [target_id] = target_give_id (target,n_total_trg,xx + ii,yy + jj);
                
                n_sus = 0;
                for sss=1:agent(agent_id).n_suspend
                    if target_id == agent(agent_id).suspend(sss)
                        n_sus = 1;
                    end
                    
                end
                
                
                
                if (target(target_id).status == 0)&&(n_sus == 0)
                    agent(agent_id).status = 1;                                 % update agent status to "found"
                    agent(agent_id).queue(1) = xx + ii;                         % save x of the target
                    agent(agent_id).queue(2) = yy+jj;                           % savw y of the target
                    agent(agent_id).queue(3) = agent(agent_id).cost(2);         % save the current cost paid  for the target
                    agent(agent_id).queue(4) = target_id;                       % save the id of  the target
                    target(target_id).cost(1) = agent(agent_id).cost(2);        % put your current cost in traget's profile
                    agent(agent_id).cost(2) = 0;                                % clear current cost
                    target(target_id).by(1) = agent_id;                         % mark your id in target's profile as hunter
                    target(agent(agent_id).queue(4)).time(1) = counter;         % mark the time of the detection in target's profile
                    agent(agent_id).queue(9) = counter;
                    target(target_id).status = 1;                               % update the  status of the target to "detected"
                    agent(agent_id).profit = agent(agent_id).profit + Ih;       % add Ih to your saving
                    agent(agent_id).quantity = agent(agent_id).quantity + 1;    % update your quantity
                end
            end
        end
        
        
        if inbound(xx+ii,yy+jj,nrows,ncols) && map_frontier(xx+ii,yy+jj) && (map_actual(xx + ii , yy + jj)==0 && (map_explored(xx + ii , yy + jj)==1))
            map_explored(xx+ii,yy+jj)=3;
            map_timer(xx+ii,yy+jj)=revealed_time;
            
        end
        
        
    end
end

% find the nearest frontier cell among all frontier cells from the shared map
% coordinate of the nearest frontier assign to new_ii and new_jj
temp = inf;
r2=max(nrows,ncols);
new_ii=xx;
new_jj=yy;

for ii = 1:r2
    
    for jj=-ii:1:ii
        
        
        if inbound(xx+ii,yy+jj,nrows,ncols) && map_explored(xx+ii,yy+jj)==3
            
            
            temp_distance = distance_astar(no_pass,[xx+ii,yy+jj], [xx,yy]);
            if temp_distance<temp
                new_ii=xx+ii;
                new_jj=yy+jj;
                temp = temp_distance;
            end
        end
        
        
        if inbound(xx-ii,yy+jj,nrows,ncols) && map_explored(xx-ii,yy+jj)==3
            temp_distance = distance_astar(no_pass,[xx-ii,yy+jj], [xx,yy]);
            if temp_distance<temp
                new_ii=xx-ii;
                new_jj=yy+jj;
                temp = temp_distance;
            end
        end
        
        if inbound(xx+jj,yy+ii,nrows,ncols) && map_explored(xx+jj,yy+ii)==3
            temp_distance = distance_astar(no_pass,[xx+jj,yy+ii], [xx,yy]);
            if temp_distance<temp
                new_ii=xx+jj;
                new_jj=yy+ii;
                temp = temp_distance;
            end
            
        end
        
        if inbound(xx+jj,yy-ii,nrows,ncols) && map_explored(xx+jj,yy-ii)==3
            temp_distance = distance_astar(no_pass,[xx+jj,yy-ii], [xx,yy]);
            if temp_distance<temp
                new_ii=xx+jj;
                new_jj=yy-ii;
                temp = temp_distance;
            end
            
        end
        
        
    end
    
    if isfinite(temp)
        break
    end
end


end