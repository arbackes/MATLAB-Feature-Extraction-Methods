function min_dist = Distance_CSS(p1,p2)
% MIN_DIST = Distance_CSS(P1,P2)
% Calcula a menor distância entre dois conjuntos de pontos calculados 
% usando a função Shape_CSS
% 
% P1: matriz de M x 2, contendo os M pontos de máxima do contorno 1
% P2: matriz de N x 2, contendo os N pontos de máxima do contorno 2
% 
% MIN_DIST: menor distância entre os dois conjuntos de pontos
% 
% F. Mokhtarian, M. Bober, Curvature Scale Space Representation: Theory,
% Applications, and MPEG-7 Standardization, Kluwer, 2003.

d1 = Compute_Distance_CSS(p1,p2);
d2 = Compute_Distance_CSS(p2,p1);

min_dist = min([d1 d2]);
%=======================================================
function dist = Compute_Distance_CSS(p1,p2)
n1 = size(p1,1);
n2 = size(p2,1);
menor = min([n1, n2]);

matching_list = [];
alpha = [];
for y=1:n1
    for x=1:n2
        d = abs(p1(y,1) - p2(x,1));
        if (d <= (0.2 * p1(y,1)))
            matching_list = [matching_list; y x];
            alpha = [alpha; p1(y,2) - p2(x,2)];
        end;        
    end;
end;

%realiza o shift
dist = zeros(1,length(alpha));
for y=1:length(alpha)
    p = p1;
    p(:,2) = p(:,2) + alpha(y);
    %shift circular
    for k=1:n1
        if (p(k,2) > 1)
            p(k,2) = p(k,2) - 1;
        else
            if (p(k,2) < 0)
                p(k,2) = 1 + p(k,2);
            end;
        end;
    end;

    for k=1:menor
        d = abs(p(k,2) - p2(k,2));      
        if (d <= 0.2)
            dist(y) = dist(y) + (sum((p(k,:) - p2(k,:)).^2).^(1/2));
        else
            dist(y) = dist(y) + (p(k,1) + p2(k,1));
        end;            
    end;    
end;

if (n1 ~= n2)
    if (n1 > n2)
        dist = dist + sum(p1(n2+1:end,1));
    else
        dist = dist + sum(p2(n1+1:end,1));
    end;
end;