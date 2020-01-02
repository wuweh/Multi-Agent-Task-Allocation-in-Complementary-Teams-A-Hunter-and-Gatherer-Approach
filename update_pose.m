%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [new_x,new_y] = update_pose (input_map, start_coords, dest_coords)

if start_coords(1)==dest_coords(1) && start_coords(2)==dest_coords(2)
    new_x=start_coords(1);
    new_y=start_coords(2);
else
    
    [distance,route] = distance_astar (input_map, start_coords, dest_coords);
    
    if distance>=1
        
        [new_x,new_y] = ind2sub(size(input_map),route(2));
    else
        new_x=start_coords(1);
        new_y=start_coords(2);
    end
    
end
