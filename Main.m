%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


clear; clc; close all,

% number of episodes for the purpose of statistical analysis
episode_max = 50;

for i=1:episode_max
    results(i).eff_h = 0;
    results(i).eff_g = 0;
    results(i).eff_t = 0;
end

a_h = 0.15*rand (episode_max,1);
b_h = 0.15*rand (episode_max,1);


%	Colors:
%	White:      Unexplored
%	Black:      Explored
%	Green:      Hunter
%	Magenta:	Gatherer
%	Red:        Targets
%	Yellow:     Frontier of exploration


cmap = [1 0 0; ...
    1 1 1; ...
    0 0 0; ...
    1 1 1; ...
    0 1 0; ...
    1 1 0; ...
    1 0 1; ...
    0.5 0.5 0.5];

colormap(cmap);

disp ("Episode No., a_Hunter, b_Hunter");

for episode=1:episode_max
    disp ([episode a_h(episode,1) b_h(episode,1)]);
    
    % initializing the environment
    % parameters
    %*********************************************************************************************
    map_actual = zeros(100,100);     % dimension of the map
    n_obc = 1;                       % number of obstacles inn the map
    n_trg = 50;                      % number of targets in the map
    iteration = 1000;                % number of iterations
    n_htr = 4;                       % number if hunter agents
    n_gtr = 2;                       % number if gatherer agents
    r_h = 3;                         % FOV of hunter agents
    r_g = 1;                         % FOV of gatherer agents
    Ih = 140;                        % income for hunting
    Ig = 140;                        % income for gathering
    Iex = 140;                       % extra income for a completed task
    f = [a_h(episode,1) b_h(episode,1) 50 0.45 0.45 1];      %[a_h b_h t_h a_g b_g q_g]
    %********************************************************************************************
    
    % initializing  the environment
    % build_up the environment according to the parameters
    %*********************************************************************************************
    
    map_actual = obstacle_formation_sparse(map_actual,n_obc);
    %map_actual = obstacle_formation;
    [map_actual,target,n_total_trg] = target_distribution(map_actual,n_trg);
    [agent,agent_g,n_htr,n_gtr]=team_up(n_htr,n_gtr,map_actual,f);
    [history] = history_up (iteration,n_htr,n_gtr,1);
    [nrows, ncols] = size(map_actual);
    map_explored = ones(nrows,ncols);
    map_timer = inf*ones(nrows,ncols);
    no_pass=false(nrows,ncols);
    n_explored=1;
    n_trg_current = n_trg;
    %********************************************************************************************
    
    for counter=1:iteration
        
        % part1
        % hunter agents' acitiviy
        %*********************************************************************************************************************
        for i_htr=1:n_htr
            
            [map_explored,no_pass,n_explored,new_ii,new_jj,agent,target,map_timer,n_total_trg]=explore_agent(map_actual,map_explored,n_explored,no_pass,i_htr,agent,target,n_trg,r_h,counter,map_timer,Ih,n_total_trg);
            
            if agent(i_htr).status ~= 0
                map_explored(agent(i_htr).coordinate(1),agent(i_htr).coordinate(2))=2;
                [agent,agent_g,target]= trade_on(agent,agent_g,i_htr,target,Ih,Iex,n_gtr);
                
            else
                dest_coords = [new_ii,new_jj];
                start_coords = [agent(i_htr).coordinate(1),agent(i_htr).coordinate(2)];
                
                % update current and total cost for the hunter agent
                agent(i_htr).cost(1)=agent(i_htr).cost(1)+1;
                agent(i_htr).cost(2)=agent(i_htr).cost(2)+1;
                [agent(i_htr).coordinate(1),agent(i_htr).coordinate(2)] = update_pose (no_pass, start_coords, dest_coords);
                map_explored(agent(i_htr).coordinate(1),agent(i_htr).coordinate(2))=2;
            end
            
            
        end
        %************************************************************************************************************
        
        % part2
        % gatherer agents' acitiviy
        %************************************************************************************************************
        for i_gtr=1:n_gtr
            
            
            if agent_g(i_gtr).status(2)~= agent_g(i_gtr).parameters(3) % if queue is not full
                
                [agent_g,agent,target]= trade_on_g(agent,agent_g,i_gtr,target,n_htr,Ig,Iex,map_actual);
                map_explored(agent_g(i_gtr).coordinate(1),agent_g(i_gtr).coordinate(2))=4;
                
            end
            
            if agent_g(i_gtr).status(2)~=0 % if your queue is not empty
                
                agent_g(i_gtr).action_plan(1) = choose_action (agent_g,i_gtr);
                [map_explored,no_pass,n_explored,agent,agent_g,target,map_timer,n_total_trg,map_actual]= explore_agent_g(map_actual,map_explored,n_explored,no_pass,i_gtr,agent_g(i_gtr).coordinate(1),agent_g(i_gtr).coordinate(2),r_g,agent,agent_g,target,counter,map_timer,n_trg_current,agent_g(i_gtr).action_plan(1),n_total_trg);
                agent_g(i_gtr).action_plan(1) = choose_action (agent_g,i_gtr);
                if agent_g(i_gtr).status(2)~=0
                    dest_coords = [agent_g(i_gtr).queue(3,agent_g(i_gtr).action_plan(1)),agent_g(i_gtr).queue(4,agent_g(i_gtr).action_plan(1))];
                    start_coords = [agent_g(i_gtr).coordinate(1),agent_g(i_gtr).coordinate(2)];
                    
                    [agent_g(i_gtr).coordinate(1),agent_g(i_gtr).coordinate(2)] = update_pose (no_pass, start_coords, dest_coords);
                    
                    agent_g(i_gtr).cost(1) = agent_g(i_gtr).cost(1)+1;
                    agent_g(i_gtr).cost(2) = agent_g(i_gtr).cost(2)+1;
                end
                [map_explored,no_pass,n_explored,agent,agent_g,target,map_timer,n_total_trg,map_actual]= explore_agent_g(map_actual,map_explored,n_explored,no_pass,i_gtr,agent_g(i_gtr).coordinate(1),agent_g(i_gtr).coordinate(2),r_g,agent,agent_g,target,counter,map_timer,n_trg_current,agent_g(i_gtr).action_plan(1),n_total_trg);
                map_explored(agent_g(i_gtr).coordinate(1),agent_g(i_gtr).coordinate(2)) = 4;
                
            end
            
            
        end
        %***********************************************************************************************************
        
        
        for ii=1:nrows
            for jj=1:ncols
                if map_timer(ii,jj)>1
                    map_timer(ii,jj)=map_timer(ii,jj)-1;
                else
                    if map_timer(ii,jj)==1
                        
                        map_explored(ii,jj)=3;
                        map_timer(ii,jj)=map_timer(ii,jj)-1;
                        break
                    end
                    if map_timer(ii,jj)==0
                        
                        map_explored(ii,jj)=1;
                    end
                end
            end
        end
        
        % part3
        % monitoring
        %************************************************************************************************************
        %     pause(0.01)
        image(1.5,1.5,map_explored+3)
        grid on;
        grid minor
        axis image
        %     campos([1,1,100]);
        drawnow;
        
    end
    %episode=1;
    [agent,agent_g,results] = analyze_mission(agent,agent_g,n_gtr,n_htr,iteration,episode,results);
    % %*************************************************************************************************************
end

for episode=1:episode_max
    result_final(episode,1) = results(episode).eff_h(1);
    result_final(episode,2) = results(episode).eff_h(2);
    result_final(episode,3) = results(episode).eff_h(3);
    result_final(episode,4) = results(episode).eff_h(4);
    result_final(episode,5) = results(episode).eff_g(1);
    result_final(episode,6) = results(episode).eff_g(2);
    result_final(episode,7) = results(episode).eff_t;
    result_final(episode,8) = a_h (episode,1);
    result_final(episode,9) = b_h (episode,1);
end