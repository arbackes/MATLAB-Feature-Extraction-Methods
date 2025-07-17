% function [CAM,ERRO] = AproxPoligonal_ProgDinamica_Contorno(CURVA,M)
% Calcula a aproximação poligonal de uma curva usando o método
% de Programação Dinâmica
% 
% Entrada:
% CURVA: matriz de N x 2, onde cada linha contém as coordenadas 
% [x y] de um ponto do contorno
% M: número de pontos que a aproximação poligonal deve ter
% 
% Saída:
% CAM: vetor contendo os índices selecionados da CURVA para 
% compor a aproximação poligonal
% ERRO: erro ISE da aproximação poligonal
% 
% Paper: J.C. Perez, E. Vidal. Optimum polygonal approximation 
% of digitized curves. Pattern Recognition Letters, 15 (1994) 
% 743-750


function [melhor_caminho,erro] = AproxPoligonal_ProgDinamica_Contorno(contorno,M)

% contorno = dlmread('..\Curvas\FIG_3.dat',' ');%chromosome
N = length(contorno);

% M = 7;
erro = 1000000;
melhor_caminho = [];

for y=1:N
    load(['.\Temp\mat_erros',int2str(y),'.mat']);
    [caminho,erro_atual] = AproxPoligonal_ProgDinamica(contorno,y,M,mat_erros);
    if erro_atual < erro 
        melhor_caminho = caminho;
        erro = erro_atual;
    end;
    
    %disp(['Ponto Inicial = ',int2str(y)]);
end;

% desenha_caminho(contorno,melhor_caminho,erro);

%--------------------------------------------------------------------------
function [caminho,erro] = AproxPoligonal_ProgDinamica(contorno,pini,nro_pontos,mat_erros)

c = [contorno(pini:end,:); contorno(1:pini,:)];
N = length(c);
% mat_erros = calcula_arcos_rede(c);
M = nro_pontos + 1;%7;

D = ones(N,M) * Inf;
D(1,1) = 0;

mat_cam = zeros(N,M);

for pm = 2:M
    for pn = pm:N
        valor = D(pm-1,pm-1) + mat_erros(pm-1,pn);
        passo = pm-1;
        for pind = (pm-1):(pn-1)
            temp = D(pind,pm-1) + mat_erros(pind,pn);
            if (temp < valor)
                valor = temp;
                passo = pind;
            end;
        end;  
        D(pn,pm) = valor;
        mat_cam(pn,pm) = passo;
    end;
end;

caminho = N;
next = mat_cam(N,M);
for pa=(M-1):-1:1
    caminho = [next caminho];
    next = mat_cam(next,pa);           
end;

caminho = caminho(1:end-1) + pini - 1;
for y=1:M-1
    if caminho(y) > N
        caminho(y) = caminho(y) - N;
    end;
end;

erro = D(N,M);