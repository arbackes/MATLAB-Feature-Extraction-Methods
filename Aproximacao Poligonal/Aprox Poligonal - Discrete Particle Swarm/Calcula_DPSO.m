% [CAM,ERRO,TAM] = Calcula_DPSO(CONTORNO,ERRO_MAX)
% Calcula a aproximação poligonal de uma curva usando o método
% the Discrete Particle Swarm Optimization (DPSO)
% 
% Entrada:
% CONTORNO: matriz de N x 2, onde cada linha contém as coordenadas 
% [x y] de um ponto do contorno
% ERRO_MAX: erro máximo (ISE) permitido para a aproximação poligonal
% 
% Saída:
% CAM: vetor contendo os índices selecionados da CURVA para 
% compor a aproximação poligonal
% ERRO: erro ISE da aproximação poligonal
% TAM: número de pontos selecionado para compor a aproximação poligonal
% 
% Paper: 
% Peng-Yeng Yin. Discrete particle swarm algorithm for optimal 
% polygonal approximation of digital curves. Journal of Visual 
% Communication and Image Representations, 15(2):241-260, 2004.

function [caminho,erro,tam] = Calcula_DPSO(contorno,Erro_maximo)

max_iteracao = 450;
vmax = 6;
c1= 2;
c2= 2;
nro_particulas = 20;
    
global_best = ones(1,length(contorno));
melhor_caminho = [];
resultados = [];

particulas = inicia_particulas(nro_particulas,contorno);
velocidades = rand(nro_particulas, length(contorno));

for iteracao = 1:max_iteracao
    fitness = calcula_fitness(particulas,contorno,Erro_maximo);    
    c = find(fitness == max(fitness));
    pbest = particulas(c(1),:);
    
    c = find(pbest == 1);
    d = find(global_best == 1);    
    if length(c) < length(d)
        global_best = pbest;
    end;
    
    velocidades = atualiza_velocidade(velocidades,particulas,pbest,global_best,vmax,c1,c2);%Talvez MUDAR
    particulas = atualiza_particulas(particulas,velocidades,vmax);    
    melhor_caminho = find(global_best == 1);
    
    %desenha_caminho(contorno,melhor_caminho,iteracao);
    
    resultados = [resultados; iteracao length(melhor_caminho) erro_arco_segmento(contorno,melhor_caminho)];
   
    %disp(['Iter = ',int2str(resultados(end,1)),' Nro Pontos = ', int2str(resultados(end,2)),' Erro = ',num2str(resultados(end,3))]);
end;

caminho = melhor_caminho;
tam = length(melhor_caminho);
erro = erro_arco_segmento(contorno,melhor_caminho);

%--------------------------------------------------------------------
function particulas = inicia_particulas(nro_particulas,contorno);

tam = length(contorno);
particulas = [];
y = 0;
while  y < nro_particulas
    x = rand(1,tam);
    c = find(x >= 0.5);
    if length(c) > 3 
        y = y + 1;
        x(:) = 0;
        x(c) = 1;
        particulas = [particulas; x];
    end;
end;

%--------------------------------------------------------------------
function fitness = calcula_fitness(particulas,contorno,Erro_maximo);
[dy,dx] = size(particulas);
fitness = zeros(1,dy);

for y=1:dy
    c = find(particulas(y,:) == 1);
    if length(c) >=3        
        erro = erro_arco_segmento(contorno,c);
        if erro > Erro_maximo
            fitness(y) = -erro/(Erro_maximo * dx);
        else
            fitness(y) = 1/length(c);
        end;        
    end;
end;

%--------------------------------------------------------------------
function v = atualiza_velocidade(velocidade,p,pbest,gbest,vmax,c1,c2);

v = velocidade;
[dy,dx]=size(velocidade);

for y=1:dy
    for x=1:dx
        v(y,x) = v(y,x) + (c1 * rand * (pbest(x)-p(y,x))) + (c2 * rand * (gbest(x)-p(y,x)));
        if v(y,x) > vmax
            v(y,x) = vmax;
        end;
    end;
end; 

%--------------------------------------------------------------------
function particulas = atualiza_particulas(p,v,vmax);

particulas = p;
[dy,dx] = size(p);
for y=1:dy
    for x=1:dx
        S = v(y,x)/(2*vmax) + 0.5;
        if rand <= S
            particulas(y,x) = 1;
        else
            particulas(y,x) = 0;
        end;            
    end;
end;

%--------------------------------------------------------------------
function erro = erro_arco_segmento(contorno,segmento);

[dy,dx]=size(contorno);
tam = length(segmento);

d = 0;
for k =1:tam
    if k == tam
        k2 = 1;
    else
        k2 = k+1;
    end;
    
    d = d + dist_arco_reta(contorno,segmento(k),segmento(k2));    
end;

erro = d;

%================================================================
%NOVO 
function dist = dist_arco_reta(contorno,pini,pfim);
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