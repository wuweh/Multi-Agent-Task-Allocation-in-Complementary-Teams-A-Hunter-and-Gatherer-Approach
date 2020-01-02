%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [agent,agent_g,n_htr,n_gtr] = team_up (n_htr,n_gtr,input_map,f)

%generating the primary matrix

for idd=1:n_htr
    agent(idd).id= idd;
    agent(idd).status=0;                    % 0=exploring 1=detected 2=waiting 3=partner_found and first offer has been sent
    agent(idd).coordinate = [1 idd];          % initial coordinate of the hunter agent
    agent(idd).cost = [0 0];                % agent(idd).cost(1)=total cost and agent(idd).cost(2)=current cost
    agent(idd).profit = 0;                  % total profit earned by the hunter agent
    agent(idd).quantity=0;                  % total number of target gathered by the hunter agent
    agent(idd).parameters = [f(1) f(2) f(3)];    % [alpha min_profit]
    agent(idd).queue = zeros(1,10);         % queue=[x y cost target_id p1 p2 p3 min_price time]
    agent(idd).temp = 0;                    %
    agent(idd).online = zeros(1,5);         % online=[agent_status  queue(1)=x_target  queue(2)=y_target queue(5)=target_id ]
    agent(idd).inbox_number = 0;
    agent(idd).inbox_id = zeros(1,n_gtr);
    agent(idd).inbox = zeros(1,n_gtr);
    agent(idd).n_suspend = 0;
    agent(idd).suspend = 0;
    agent(idd).waiting_time = 0;
    agent(idd).results = 0;
end

clear idd

for idd=1:n_gtr
    agent_g(idd).id = idd;                                            % agent id
    agent_g(idd).status = [0 0];                                    % agent_g(idd).status(1):trade_status  and agent_g(idd).status(2):queue status
    agent_g(idd).coordinate = [2 idd];                                % initial coordinate of the gatherer agent
    agent_g(idd).cost = [0 0];                                      % [total_cost current_cost
    agent_g(idd).profit = 0;                                        % total profit earned by the gatherer agent
    agent_g(idd).quantity = 0;                                        % total number of targets gathered by the gatherer agent
    agent_g(idd).parameters = [f(4) f(5) f(6)];                           % [alpha min_profit]
    agent_g(idd).temp = [0 0 0];                                    % [partner_id expected_cost generated_bid]
    agent_g(idd).online = zeros(1,3);                                % online board of the gatherer agent
    agent_g(idd).inbox = zeros(1,5);                                % [partner_id offer/min_bid method(1=bargain and 2=auction)]
    agent_g(idd).results = 0;                                       % cost to profit ratio of the agent
    agent_g(idd).queue = zeros(10,agent_g(idd).parameters(3)+1);    % each queue = [partner_id ]
    agent_g(idd).action_plan = [0];
    
end
clear idd


%*******************************************************************************************************
%assigning a random start coordinate for hunter agents
%hunter agents will be distributed only on edges of the map

[MAX_X,MAX_Y]=size(input_map);
n_htr_p=0;

while n_htr_p ~= n_htr
    temp_x=randi(MAX_X);
    temp_y=randi(MAX_Y);
    if temp_x==1 || temp_x==MAX_X || temp_y==1 || temp_x==MAX_Y
        
        n_htr_p=n_htr_p+1;
        agent(n_htr_p).coordinate(1)=temp_x;
        agent(n_htr_p).coordinate(2)=temp_y;
        
    end
end
%**********************************************************************************************************
%assigning a random start coordinate for gatherer agents
%gatherer agents will be distributed only on edges of the map

[MAX_X,MAX_Y]=size(input_map);
n_gtr_p=0;

while n_gtr_p ~= n_gtr
    temp_x=randi(MAX_X);
    temp_y=randi(MAX_Y);
    if temp_x==1 || temp_x==MAX_X || temp_y==1 || temp_x==MAX_Y
        
        n_gtr_p=n_gtr_p+1;
        agent_g(n_gtr_p).coordinate(1)=temp_x;
        agent_g(n_gtr_p).coordinate(2)=temp_y;
        
    end
end

end