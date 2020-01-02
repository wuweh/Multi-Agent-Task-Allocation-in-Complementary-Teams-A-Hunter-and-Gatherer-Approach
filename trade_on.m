%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [agent,agent_g,target]= trade_on(agent,agent_g,agent_id,target,Ih,Iex,n_gtr)

%*******************************************************************************
if agent(agent_id).status == 1
    
    agent(agent_id).status = 2;                                               % update the status of agent
    agent(agent_id).online = [agent(agent_id).status agent(agent_id).queue(1) agent(agent_id).queue(2) agent(agent_id).queue(4) agent(agent_id).queue(9)];
    [agent(agent_id).queue(5), agent(agent_id).queue(6), agent(agent_id).queue(7), agent(agent_id).queue(8), price_flag] = price_h (Iex,Ih,agent(agent_id).queue(3),agent(agent_id).parameters(1),agent(agent_id).parameters(2),agent);
    
    
    if price_flag == 0
        
        agent(agent_id).status = 0;                                                       % update your status
        target(agent(agent_id).queue(4)).status = 0;
        target(agent(agent_id).queue(4)).by(1) = 0;
        target(agent(agent_id).queue(4)).cost(1) = 0;
        agent(agent_id).n_suspend = agent(agent_id).n_suspend + 1;
        agent(agent_id).quantity = agent(agent_id).quantity - 1;
        agent(agent_id).suspend(agent(agent_id).n_suspend) = agent(agent_id).queue(4);
        agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;                    % clear your inbox_number
        agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;                            % clear your inbox_id
        agent(agent_id).inbox = 0*agent(agent_id).inbox;                                  % clear your inbox
        agent(agent_id).online = 0*agent(agent_id).online;                                % clear your online board
        agent(agent_id).queue = 0*agent(agent_id).queue;                                  % clear your queue
        agent(agent_id).waiting_time = 0;
        
    end
    
    %*******************************************************************************
elseif agent(agent_id).status==2
    
    agent(agent_id).waiting_time = agent(agent_id).waiting_time +1;
    if (agent(agent_id).waiting_time > agent(agent_id).parameters(3))&&(agent(agent_id).inbox_number==0)
        agent(agent_id).status = 0;                                                       % update your status
        target(agent(agent_id).queue(4)).status = 0;
        target(agent(agent_id).queue(4)).by(1) = 0;
        target(agent(agent_id).queue(4)).cost(1) = 0;
        agent(agent_id).n_suspend = agent(agent_id).n_suspend + 1;
        agent(agent_id).quantity = agent(agent_id).quantity - 1;
        agent(agent_id).suspend(agent(agent_id).n_suspend) = agent(agent_id).queue(4);
        agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;                    % clear your inbox_number
        agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;                            % clear your inbox_id
        agent(agent_id).inbox = 0*agent(agent_id).inbox;                                  % clear your inbox
        agent(agent_id).online = 0*agent(agent_id).online;                                % clear your online board
        agent(agent_id).queue = 0*agent(agent_id).queue;                                  % clear your queue
        agent(agent_id).waiting_time = 0;
    end
    
    
    
    if agent(agent_id).inbox_number~=0 %if you received any message
        
        [agent] = read_inbox_id_h(agent_id,agent,n_gtr);
        if agent(agent_id).inbox_number ==1 % if the method is bargaining
            
            agent_g(agent(agent_id).temp(1)).inbox(3) = 1;                                  % send method of the trade to your partner
            agent_g(agent(agent_id).temp(1)).inbox(1) = agent_id;                           % send your id to your partner for verification
            agent_g(agent(agent_id).temp(1)).inbox(2) = (1-agent(agent_id).queue(5))*Iex;   % send the first offer to your partner based on p3
            agent(agent_id).status=3;
            agent(agent_id).online(1)=agent(agent_id).status;
            
        elseif agent(agent_id).inbox_number>1
            [aa bb] = size(agent(agent_id).temp);
            agent(agent_id).status = 3;
            agent(agent_id).online(1)=agent(agent_id).status;
            for ii=1:bb
                agent_g(agent(agent_id).temp(ii)).inbox(3) = 2;
                agent_g(agent(agent_id).temp(ii)).inbox(1) = agent_id;
                agent_g(agent(agent_id).temp(ii)).inbox(2) = 0;
            end
            
        end
    end
    
    
    
    %**************************************************************************************
elseif agent(agent_id).status==3
    if agent(agent_id).inbox_number == 1
        if  (agent(agent_id).inbox(1)==1) % if you received an acceptance message
            
            agent(agent_id).profit = agent(agent_id).profit + agent(agent_id).queue(5)*Iex;   % add your share of Iex to your saving
            target(agent(agent_id).queue(4)).share_results(1) = agent(agent_id).queue(5)*Iex; % mark your share of Iex in target's profile
            target(agent(agent_id).queue(4)).share_method = [1 1];                            % mark the share method in target's profile
            agent(agent_id).status = 0;                                                       % update your status
            agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;                    % clear your inbox_number
            agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;                            % clear your inbox_id
            agent(agent_id).inbox = 0*agent(agent_id).inbox;                                  % clear your inbox
            agent(agent_id).online = 0*agent(agent_id).online;                                % clear your online board
            agent(agent_id).queue = 0*agent(agent_id).queue;                                  % clear your queue
            
        else
            agent(agent_id).status=4;
            agent(agent_id).online(1)=agent(agent_id).status;
            agent_g(agent(agent_id).temp(1)).inbox(3) = 1;                                  % send method of the trade to your partner
            agent_g(agent(agent_id).temp(1)).inbox(1) = agent_id;                           % send your id to your partner for verification
            agent_g(agent(agent_id).temp(1)).inbox(2) = (1-agent(agent_id).queue(6))*Iex;   % send the second offer to your partner based on p3
            agent(agent_id).inbox = 0*agent(agent_id).inbox; % clear your inbox
        end
    elseif agent(agent_id).inbox_number > 1
        
        [agent(agent_id).queue(9),agent(agent_id).queue(10),acc_flag] = choose_winner (agent_id,agent,Iex,Ih,agent(agent_id).queue(3),agent(agent_id).parameters(1),agent(agent_id).parameters(2),n_gtr);
        
        if (acc_flag == 1) && (agent(agent_id).inbox_id(agent(agent_id).queue(9))~=0)
            agent_g(agent(agent_id).queue(9)).inbox(1) = agent_id;
            agent_g(agent(agent_id).queue(9)).inbox(2) = 1;
            agent(agent_id).profit= agent(agent_id).profit+agent(agent_id).queue(10);
            agent(agent_id).status = 0;
            target(agent(agent_id).queue(4)).share_results(1) = agent(agent_id).queue(10);      % mark your share of Iex in target's profile
            target(agent(agent_id).queue(4)).share_method = [2 agent(agent_id).inbox_number];                            % mark the share method in target's profile
            agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;                            % clear your inbox_id
            agent(agent_id).inbox_number = 0;
            agent(agent_id).inbox = 0*agent(agent_id).inbox;                                  % clear your inbox
            agent(agent_id).online = 0*agent(agent_id).online;                                % clear your online board
            agent(agent_id).queue = 0*agent(agent_id).queue;                                  % clear your queue
            agent(agent_id).temp = 0;
        else
            
            agent(agent_id).status=2;
            agent(agent_id).inbox = 0*agent(agent_id).inbox; % clear your inbox
            agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;
            agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;
        end
    end
    %******************************************************************************************
elseif agent(agent_id).status==4 % if your first offer has been rejected
    
    if  (agent(agent_id).inbox(1)==1) %if you received an acceptance message
        
        agent(agent_id).profit = agent(agent_id).profit + agent(agent_id).queue(6)*Iex;   % add your share of Iex to your saving
        target(agent(agent_id).queue(4)).share_results(1) = agent(agent_id).queue(6)*Iex; % mark your share of Iex in target's profile
        target(agent(agent_id).queue(4)).share_method = [1 2];                            % mark the share method in target's profile
        agent(agent_id).status = 0;                                                       % update your status
        agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;                    % clear your inbox_number
        agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;                            % clear your inbox_id
        agent(agent_id).inbox = 0*agent(agent_id).inbox;                                  % clear your inbox
        agent(agent_id).online = 0*agent(agent_id).online;                                % clear your online board
        agent(agent_id).queue = 0*agent(agent_id).queue;                                  % clear your queue
        
    else
        agent(agent_id).status=5;
        agent(agent_id).online(1)=agent(agent_id).status;
        agent_g(agent(agent_id).temp(1)).inbox(3) = 1;                                  % send method of the trade to your partner
        agent_g(agent(agent_id).temp(1)).inbox(1) = agent_id;                           % send your id to your partner for verification
        agent_g(agent(agent_id).temp(1)).inbox(2) = (1-agent(agent_id).queue(7))*Iex;   % send the third offer to your partner based on p3
        
        agent(agent_id).inbox = 0*agent(agent_id).inbox; % clear your inbox
    end
    
    
    
    %*****************************************************************************************
    
elseif agent(agent_id).status==5 % if your first offer has been rejected
    
    if  (agent(agent_id).inbox(1)==1) %if you received an acceptance message
        
        agent(agent_id).profit = agent(agent_id).profit + agent(agent_id).queue(7)*Iex;   % add your share of Iex to your saving
        target(agent(agent_id).queue(4)).share_results(1) = agent(agent_id).queue(7)*Iex; % mark your share of Iex in target's profile
        target(agent(agent_id).queue(4)).share_method = [1 3];                            % mark the share method in target's profile
        agent(agent_id).status = 0;                                                       % update your status
        agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;                    % clear your inbox_number
        agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;                            % clear your inbix_id
        agent(agent_id).inbox = 0*agent(agent_id).inbox;                                  % clear your inbox
        agent(agent_id).online = 0*agent(agent_id).online;                                % clear your online board
        agent(agent_id).queue = 0*agent(agent_id).queue;                                  % clear your queue
        
    else
        agent(agent_id).status=2;
        agent(agent_id).inbox = 0*agent(agent_id).inbox; % clear your inbox
        agent(agent_id).inbox_number = 0*agent(agent_id).inbox_number;
        agent(agent_id).inbox_id = 0*agent(agent_id).inbox_id;
    end
    
    %*****************************************************************************************
end
end