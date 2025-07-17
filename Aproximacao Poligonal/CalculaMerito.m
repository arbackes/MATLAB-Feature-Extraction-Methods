% function [Merito,Fidelidade,Eficiencia] = CalculaMerito(Maprox, Eaprox, pontos)
% Calcula o mérito, afidelidade e aeficiência de uma aproximação poligonal
% 
% Entrada:
% Maprox: número de pontos da aproximação poligonal avaliada
% Eaprox: erro (ISE) da aproximação poligonal avaliada
% pontos: matrix [N x 2] contendo o número de pontos e o erro (ISE) da
% aproximação poligonal ideal (calculada com programação dinâmica)
% 
% Saída:
% Merito
% Fidelidade
% Eficiencia 
% 

function [Merito,Fidelidade,Eficiencia] = CalculaMerito(Maprox, Eaprox, pontos)
    %pontos = pontos ProgDinamica
    %p = pontos para calular

    N = size(pontos,1);
    if (Eaprox > pontos(1,2))
        ind = [1,2];
    else
        if (Eaprox < pontos(end,2))
            ind = [N-1,N];
        else
            for x=1:N-1
                if ((Eaprox <= pontos(x,2)) && (Eaprox >= pontos(x+1,2)))
                    ind = [x,x+1];
                end;
            end;
        end;
    end;

    [p,s] = polyfit(pontos(ind,2),pontos(ind,1),1);
    Mopt = (Eaprox*p(1) + p(2));

    c = find(pontos(:,1) == Maprox);
    Eopt = pontos(c,2);

    Fidelidade = 100 * Eopt/Eaprox;
    Eficiencia = 100 * Mopt/Maprox;
    Merito = sqrt(Fidelidade * Eficiencia);
end