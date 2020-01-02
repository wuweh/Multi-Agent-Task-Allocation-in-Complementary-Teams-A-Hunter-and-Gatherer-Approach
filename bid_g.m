%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748

function  [bid,bid_flag] = bid_g (Iex,Ig,alpha,beta,cost)
bid_flag = 0;
bid = 0;
for i=0:100
    
    if ( beta*(i/100)*Iex + alpha*Ig - cost>0 )
        bid = ((100-i)/100)*Iex;
        bid_flag = 1;
        break
    end
end

end
