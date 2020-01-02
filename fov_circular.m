%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [map_view,map_frontier,no_pass,map_view_notblocked] = fov_circular (x,y,map_actual,no_pass,r);

[ncols , nrows] = size(map_actual);
map_view     = false(ncols , nrows);
map_frontier = false(ncols , nrows);
map_view_notblocked = false(ncols , nrows);

for ii = -r:1:r
    for jj = -r:1:r
        
        if inbound(x+ii,y+jj,ncols , nrows) && distance(x+ii,y+jj,x,y)<r
            map_view(x+ii,y+jj)=1; %explored
            map_view_notblocked(x+ii,y+jj)=1;
            
        end
        
        if inbound(x+ii,y+jj,ncols , nrows) && distance(x+ii,y+jj,x,y)>=r && distance(x+ii,y+jj,x,y)<r+1
            
            map_frontier(x+ii,y+jj)=1; %frontier
            
        end
    end
end


for ii=-r-1:1:r+1
    for jj=-r-1:1:r+1
        
        %            x
        %            y
        %            ii
        %            jj
        %
        temp1=x+sign(ii)*(r+1);
        temp2=y+sign(jj)*(r+1);
        
        if temp1<=0
            temp1=1;
        end
        if  temp2<=0
            temp2=1;
        end
        
        if temp1>ncols
            temp1=ncols;
        end
        if  temp2>nrows
            temp2=nrows;
        end
        
        
        if inbound(x+ii,y+jj,ncols,nrows) && map_actual(x+ii , y+jj)~=0 && ii~=0 && jj~=0
            
            map_view( x+ii : sign(ii) : temp1  ,  y+jj : sign(jj) : temp2)=0;
            map_frontier( x+ii : sign(ii) : temp1  ,  y+jj : sign(jj) : temp2)=0;
            no_pass (x+ii , y+jj)=true;
            
        end
        
        if ii==0 && inbound(x+ii,y+jj,ncols,nrows) && map_actual(x+ii , y+jj)~=0
            map_view( x  ,  y+jj : sign(jj) : temp2)=0;
            map_frontier( x  ,  y+jj : sign(jj) : temp2)=0;
            no_pass (x+ii , y+jj)=true;
            
        end
        
        if jj==0 && inbound(x+ii,y+jj,ncols,nrows) && map_actual(x+ii , y+jj)~=0
            map_view( x+ii : sign(ii) : temp1  ,  y)=0;
            map_frontier( x+ii : sign(ii) : temp1  ,  y)=0;
            no_pass (x+ii , y+jj)=true;
            
        end
    end
end



