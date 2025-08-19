function [colorT,mapaColorT] = colorTable(N)
% [COLORT,MAPACOLORT] = colorTable(N)
% Faz a amostragem do espaço de cores RGB utilizando N tons por canal.
% 
% N: numero de tons por canal RGB.
% 
% COLORT: matrix [N*N*N x 3] contendo a nova tabela de cores.
% 
% MAPACOLORT: matriz [256 x 256 x 256] contendo o indice de cada cor do
% espaço RGB de acordo com a tabela de cores COLORT.

n = N-1;
d = round(256/n);
colorT = zeros(N*N*N,3);
tons = 0:d:256;
if (length(tons) < N)
    tons = [tons, 255];
else
    tons(end) = 255;
end;

c = 0;
for r = tons
    for g = tons
        for b = tons
            c = c + 1;
            colorT(c,:) = [r g b];
        end;
    end;
end;

mapaColorT = zeros(256,256,256);
N3 = N*N*N;
dist = zeros(1,N3);
for r = 0:255
    for g = 0:255
        for b = 0:255
            cor = [r g b];
            for k=1:N3
                dist(k) = sum((cor - colorT(k,:)).^2);
            end;
            [~,ind] = min(dist);
            mapaColorT(r+1,g+1,b+1) = ind(1);            
        end;
    end;
end;
