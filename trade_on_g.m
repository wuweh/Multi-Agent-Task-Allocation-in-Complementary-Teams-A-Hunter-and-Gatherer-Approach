%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [agent_g,agent,target]= trade_on_g(agent,agent_g,agent_id,target,n_htr,Ig,Iex,map_actual)
%***************************************************************************************************
trade_status = agent_g(agent_id).status(1);
alpha = agent_g(agent_id).parameters(1);
beta = agent_g(agent_id).parameters(2);
inbox_id = agent_g(agent_id).inbox(1);
inbox_offer = agent_g(agent_id).inbox(2);
inbox_mode = agent_g(agent_id).inbox(3);
expected_cost = agent_g(agent_id).queue(7,agent_g(agent_id).parameters(3)+1);

%***************************************************************************************************
if  trade_status==0                                              % if there is no on-going trade on
    
    [agent_g,agent] = find_partner(n_htr,agent,agent_g,agent_id,map_actual,Ig,Iex);    % choose a partner and send the readiness message
    
    %*****************************************************************************************************
elseif trade_status==1    % if you have already found a partner and sent the readiness message
    
    
    if agent_g(agent_id).inbox(3)==1
        a = agent_g(agent_id).inbox(1);
        b = agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1);
        
        if (a==b)&&(beta*inbox_offer + alpha*Ig - expected_cost>0)
            agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(1) = 1;    % send an acceptance message to the partner
            agent_g(agent_id).status(1) = 0;                                                     % set your status to idle for trading
            
            free = free_queue (agent_g,agent_id);
            
            agent_g(agent_id).queue(:,free) = agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(2,free) = agent_g(agent_id).inbox(2);
            
            agent_g(agent_id).queue(6,:) = agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(9,:) = agent_g(agent_id).queue(10,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
            agent_g(agent_id).status(2) = agent_g(agent_id).status(2) + 1;
            
            agent_g(agent_id).profit = agent_g(agent_id).profit + Ig;                                                                                    % add Ig to your saving
            agent_g(agent_id).quantity = agent_g(agent_id).quantity + 1;                                                                                 % update your backpack
            
            target(agent_g(agent_id).queue(5,free)).by(2) = agent_id;                                                             % mark your id in target's profile
            target(agent_g(agent_id).queue(5,free)).share_results(2) = agent_g(agent_id).queue(2,free);    % mark your share of Iex in traget's profile
            
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;                                                                                         % clear your inbox
            
        else
            
            agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(1) = 0;
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;
            agent_g(agent_id).status(1)=2;
            
        end % margin check
        
    elseif agent_g(agent_id).inbox(3) ==2
        [agent_g(agent_id).queue(8,agent_g(agent_id).parameters(3)+1)] = bid_g(Iex,Ig,agent_g(agent_id).parameters(1),agent_g(agent_id).parameters(2),agent_g(agent_id).queue(7,agent_g(agent_id).parameters(3)+1));
        agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(agent_id)= agent_g(agent_id).queue(8,agent_g(agent_id).parameters(3)+1);
        agent_g(agent_id).status(1)=2;
        
    end % inbox 3
    %*****************************************************************************************************
elseif trade_status==2 % if you have rejected the fist offer
    
    
    if agent_g(agent_id).inbox(3)==1
        a = agent_g(agent_id).inbox(1);
        b = agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1);
        
        if (a==b)&&(beta*inbox_offer + alpha*Ig - expected_cost>0)
            
            agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(1) = 1;       % send an acceptance message to the partner
            agent_g(agent_id).status(1) = 0;                                                        % set your status to idle for trading
            
            free = free_queue (agent_g,agent_id);
            
            agent_g(agent_id).queue(:,free) = agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(2,free) = agent_g(agent_id).inbox(2);
            
            agent_g(agent_id).queue(6,:) = agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(9,:) = agent_g(agent_id).queue(10,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
            
            agent_g(agent_id).status(2) = agent_g(agent_id).status(2) + 1;
            
            agent_g(agent_id).profit = agent_g(agent_id).profit + Ig;                                                                                    % add Ig to your saving
            agent_g(agent_id).quantity = agent_g(agent_id).quantity + 1;                                                                                 % update your backpack
            
            target(agent_g(agent_id).queue(5,free)).by(2) = agent_id;                                                             % mark your id in target's profile
            target(agent_g(agent_id).queue(5,free)).share_results(2) = agent_g(agent_id).queue(2,free);    % mark your share of Iex in traget's profile
            
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;                                                                                         % clear your inbox
            
        else
            
            agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(1) = 0;
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;
            agent_g(agent_id).status(1)=3;
            
        end % margin check
    elseif agent_g(agent_id).inbox(3) ==2
        if agent_g(agent_id).inbox(2)==1
            
            agent_g(agent_id).status(1) = 0;                                                                                  % set your status to idle for trading
            
            free = free_queue (agent_g,agent_id);
            
            agent_g(agent_id).queue(:,free) = agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(2,free) = Iex-agent_g(agent_id).queue(8,free);
            
            agent_g(agent_id).queue(6,:) = agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(9,:) = agent_g(agent_id).queue(10,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
            
            agent_g(agent_id).status(2) = agent_g(agent_id).status(2) + 1;
            
            agent_g(agent_id).profit = agent_g(agent_id).profit + Ig;                                                                                    % add Ig to your saving
            agent_g(agent_id).quantity = agent_g(agent_id).quantity + 1;                                                                                 % update your backpack
            
            target(agent_g(agent_id).queue(5,free)).by(2) = agent_id;                                                             % mark your id in target's profile
            target(agent_g(agent_id).queue(5,free)).share_results(2) = agent_g(agent_id).queue(2,free);    % mark your share of Iex in traget's profile
            
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;                                                                                         % clear your inbox
            
        else
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);               % clear temp
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;
            agent_g(agent_id).status(1)=0;
        end % auction winning
    end % inbox 3
    %******************************************************************************************************************************
elseif trade_status==3 % if you have rejected the second offer
    
    if agent_g(agent_id).inbox(3)==1
        a = agent_g(agent_id).inbox(1);
        b = agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1);
        if (a==b)&&(beta*inbox_offer + alpha*Ig - expected_cost>0)
            
            agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(1) = 1;                                                                                                 % send an acceptance message to the partner
            agent_g(agent_id).status(1) = 0;                                                                                  % set your status to idle for trading
            
            free = free_queue (agent_g,agent_id);
            
            agent_g(agent_id).queue(:,free) = agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);
            agent_g(agent_id).queue(2,free) = agent_g(agent_id).inbox(2);
            
            agent_g(agent_id).queue(6,:) = agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(9,:) = agent_g(agent_id).queue(10,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
            
            agent_g(agent_id).status(2) = agent_g(agent_id).status(2) + 1;
            
            agent_g(agent_id).profit = agent_g(agent_id).profit + Ig;                                                                                    % add Ig to your saving
            agent_g(agent_id).quantity = agent_g(agent_id).quantity + 1;                                                                                 % update your backpack
            
            target(agent_g(agent_id).queue(5,free)).by(2) = agent_id;                                                             % mark your id in target's profile
            target(agent_g(agent_id).queue(5,free)).share_results(2) = agent_g(agent_id).queue(2,free);    % mark your share of Iex in traget's profile
            
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;                                                                                         % clear your inbox
            
        else
            
            agent(agent_g(agent_id).queue(1,agent_g(agent_id).parameters(3)+1)).inbox(1) = 0;
            agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1) = 0*agent_g(agent_id).queue(:,agent_g(agent_id).parameters(3)+1);               % clear temp
            agent_g(agent_id).queue(7,:) = 0*agent_g(agent_id).queue(7,:);
            agent_g(agent_id).queue(10,:) = 0*agent_g(agent_id).queue(10,:);
            agent_g(agent_id).inbox = 0*agent_g(agent_id).inbox;
            agent_g(agent_id).status(1)=0;
            
        end % margin check
    end % inbox 3
    %******************************************************************************************************

end %status
end %function