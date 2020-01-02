%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function inbound_check = inbound(x,y,nrows,ncols);

inbound_check = false;
if (x >0 && x<=nrows) && (y>0 && y<=ncols)
    inbound_check = true;
end
end

