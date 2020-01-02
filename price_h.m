%     This code is a multi-agent task allocation analysis platform.
%     A game-theoretic decision-making approach has been utilized in this code.
%     This project aims to investigate the effect of using heterogeneous groups of robots,
%     with different capabilities, to accomplish a set of sub-tasks in order to improve efficiency.
%
%     Authors: Mehdi Dadvar, Saeed Moazami
%
%     For more information please refer to:
%     https://arxiv.org/pdf/1912.05748


function [p1,p2,p3,min_price,price_flag] = price_h (Iex,Ih,cost,alpha,beta,agent)
p1 = 0;
p2 = 0;
p3 = 0;
min_price = 0;

price_flag = 0;
for pp=0:100
    
    if ( beta*(pp/100)*Iex+alpha*Ih - cost>0 )
        
        p1 = pp/100;
        p3 = 99/100;
        p2 = ((p1+p3)/2);
        price_flag = 1;
        min_price = p1;
        break
    end
end
clear pp
end
