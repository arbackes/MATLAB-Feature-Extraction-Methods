function arcos = calcula_arcos_rede(contorno);%NOVO 
[dy,dx]= size(contorno);
arcos = zeros(dy,dy);

for y = 1:dy    
    for x =1:dy
        if y~=x
            arcos(y,x) = dist_arco_reta(contorno,y,x);
        end;
    end;
end;

%==========================================================================
function dist = dist_arco_reta(contorno,pini,pfim);
%NOVO 
[dy,dx]=size(contorno);
[A,B,C] = dist_ponto_reta(contorno(pini,:),contorno(pfim,:));
dist = 0;
li = pini;
while li ~= pfim
    if A == Inf
        dist = dist + (contorno(li,1)-contorno(pfim,1))^2;
    else
        dist = dist + ((A*contorno(li,1) + B*contorno(li,2) + C)^2)/(A*A + B*B);
    end;
    
    li = li+1;
    if li > dy
        li = 1;
    end;
end;

%==========================================================================
function [A,B,C] = dist_ponto_reta(p1,p2);

if (p2(1)-p1(1)) ==0
    A = Inf;
    B = Inf;
    C = Inf;
else
    m = (p2(2) - p1(2))/(p2(1) - p1(1));
    q = p1(2) - p1(1)*m;
    
    A = -m;
    B = 1;
    C = -q;
end;