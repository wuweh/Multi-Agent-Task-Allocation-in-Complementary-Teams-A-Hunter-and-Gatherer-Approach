%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%     This code is inspired from coursera's computational motion planning course by UPenn.
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [distance,route] = distance_astar (input_map, start_coords, dest_coords)

input_map=logical(input_map);

[nrows, ncols] = size(input_map);

map = zeros(nrows,ncols);

map(~input_map) = 1;
map(input_map)  = 2;
start_node = sub2ind(size(map), start_coords(1), start_coords(2));
dest_node  = sub2ind(size(map), dest_coords(1),  dest_coords(2));

map(start_node) = 5;
map(dest_node)  = 6;

parent = zeros(nrows,ncols);

[X, Y] = meshgrid (1:nrows, 1:ncols);

xd = dest_coords(1);
yd = dest_coords(2);

H = abs(X - xd) + abs(Y - yd);
H = H';
f = Inf(nrows,ncols);
g = Inf(nrows,ncols);

g(start_node) = 0;
f(start_node) = H(start_node);

numExpanded = 0;

count1=1;
while true
    map(start_node) = 5;
    map(dest_node) = 6;
    
    [min_f, current] = min(f(:));
    
    if ((current == dest_node) || isinf(min_f))
        break;
    end
    
    map(current) = 3;
    f(current) = Inf;
    
    [i, j] = ind2sub(size(f), current);
    
    if (i>1 && i<=nrows)
        ii = i-1;
        jj = j;
        if (map(ii,jj)~=2 && map(ii,jj)~=3 && map(ii,jj)~=5)
            if g(ii,jj) > (g(i,j) + (H(ii,jj)-H(i,j)))
                g(ii,jj) = g(i,j) + (H(ii,jj)-H(i,j));
                f(ii,jj) = g(ii,jj) + H(ii,jj);
                map(ii,jj) = 4;
                parent(ii,jj) = current;
            end
        end
    end
    if (i>=1 && i<nrows)
        ii = i+1;
        jj = j;
        if (map(ii,jj)~=2 && map(ii,jj)~=3 && map(ii,jj)~=5)
            if g(ii,jj) > (g(i,j) + (H(ii,jj)-H(i,j)))
                g(ii,jj) = g(i,j) + (H(ii,jj)-H(i,j));
                f(ii,jj) = g(ii,jj) + H(ii,jj);
                map(ii,jj) = 4;
                parent(ii,jj) = current;
            end
        end
    end
    if (j>1 && j<=ncols)
        jj = j-1;
        ii = i;
        if (map(ii,jj)~=2 && map(ii,jj)~=3 && map(ii,jj)~=5)
            if g(ii,jj) > (g(i,j) + (H(ii,jj)-H(i,j)))
                g(ii,jj) = g(i,j) + (H(ii,jj)-H(i,j));
                f(ii,jj) = g(ii,jj) + H(ii,jj);
                map(ii,jj) = 4;
                parent(ii,jj) = current;
            end
        end
    end
    if (j>=1 && j<ncols)
        jj =j+1;
        ii = i;
        if (map(ii,jj)~=2 && map(ii,jj)~=3 && map(ii,jj)~=5)
            if g(ii,jj) > (g(i,j) + (H(ii,jj)-H(i,j)))
                g(ii,jj) = g(i,j) + (H(ii,jj)-H(i,j));
                f(ii,jj) = g(ii,jj) + H(ii,jj);
                map(ii,jj) = 4;
                parent(ii,jj) = current;
            end
        end
    end
    
    numExpanded = numExpanded + 1;
    f(current) = Inf;
    count1=count1+1;
    
end

if (isinf(f(dest_node)))
    route = zeros(1,(nrows+ncols));
else
    route = [dest_node];
    
    while (parent(route(1)) ~= 0)
        route = [parent(route(1)), route];
    end
end

distance = size(route,2)-1;
end
