%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [agent_g,agent] = find_partner (n_htr,agent,agent_g,agent_id,map_actual,Ig,Iex)

[sort_online,online_flag,n_online] = sort_wating (agent,n_htr);
if online_flag==1
    for idd = 1:n_online
        %__________________________________________________________________________
        
        agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1) = sort_online(idd);
        agent_g(agent_id).queue(2 , agent_g(agent_id).parameters(3)+1) = Iex;
        agent_g(agent_id).queue(3,agent_g(agent_id).parameters(3)+1) = agent(sort_online(idd)).online(2);
        agent_g(agent_id).queue(4,agent_g(agent_id).parameters(3)+1) = agent(sort_online(idd)).online(3);
        agent_g(agent_id).queue(5,agent_g(agent_id).parameters(3)+1) = agent(sort_online(idd)).online(4);
        
        current_x = agent_g(agent_id).coordinate(1);
        current_y = agent_g(agent_id).coordinate(2);
        dist_min = inf;
        jj_min = 0;
        verify_flag = 0;
        % set temp priority for each queue of the gathere agent
        %__________________________________________________________________________
        
        for pp = 1:agent_g(agent_id).status(2)+1
            for jj = 1:agent_g(agent_id).parameters(3)+1
                if (agent_g(agent_id).queue(1,jj)~=0) && (agent_g(agent_id).queue(10,jj)==0)
                    
                    [dist_temp,route] = distance_astar (map_actual,[current_x current_y],[agent_g(agent_id).queue(3,jj) agent_g(agent_id).queue(4,jj)]);
                    
                    if  dist_temp < dist_min
                        dist_min = dist_temp;
                        jj_min = jj;
                    end
                end
            end
            agent_g(agent_id).queue(10,jj_min) = pp;
            agent_g(agent_id).queue(7,jj_min) = dist_min;
            current_x = agent_g(agent_id).queue (3,jj_min);
            current_y = agent_g(agent_id).queue (4,jj_min);
            jj_min=0;
            dist_min=inf;
        end
        clear jj
        clear pp
        %**************************************************************************
        % check validation formula for existing queues
        %__________________________________________________________________________
        for ii = 1:agent_g(agent_id).parameters(3)+1
            if agent_g(agent_id).queue(1,ii)~= 0
                if ( agent_g(agent_id).parameters(2)*agent_g(agent_id).queue(2,ii) + agent_g(agent_id).parameters(1)*Ig - agent_g(agent_id).queue(7,ii)> 0 )
                    verify_flag = verify_flag + 1;
                end
            end
        end
        % check validation result and finalize the partner selection
        %__________________________________________________________________________
        found_flag = 0;
        if verify_flag == agent_g(agent_id).status(2)+1
            agent_g(agent_id).queue (2 , agent_g(agent_id).parameters(3)+1) = 0;
            agent(sort_online(idd)).inbox_id(agent_id)=agent_id;
            agent(sort_online(idd)).inbox_number = agent(sort_online(idd)).inbox_number + 1;
            agent_g(agent_id).status(1) = 1;
            found_flag = 1;
        else
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
        end
        
        %__________________________________________________________________________
        
        if found_flag == 1
            break
        end
    end
end
%***********************************************************************************************************************
clear idd
clear jj
clear pp

end
