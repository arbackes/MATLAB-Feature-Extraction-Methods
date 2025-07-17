% [CAMINHO,ERRO,TAM] = Calcula_ACS(CONTORNO,MAX_ERRO,LIMIAR)
% Calcula a aproximação poligonal de uma curva usando o método
% Ant Colony Search (ACS)
% 
% Entrada:
% CONTORNO: matriz de N x 2, onde cada linha contém as coordenadas 
% [x y] de um ponto do contorno
% MAX_ERRO: erro máximo (ISE) permitido para a aproximação poligonal
% LIMIAR: erro máximo (ISE) permitido para um arco
% 
% Saída:
% CAMINHO: vetor contendo os índices selecionados da CURVA para 
% compor a aproximação poligonal
% ERRO: erro ISE da aproximação poligonal
% TAM: número de pontos selecionado para compor a aproximação poligonal
% 
% Paper: 
% Peng-Yeng Yin. Ant colony search algorithms for optimal polygonal 
% approximation of plane curves. Pattern Recognition, 36(8):1783-1797, 2003

function [caminho,erro,tam] = Calcula_ACS(contorno,Erro_Global,limiar)
% function ACS
%  contorno = dlmread('girl.dat',' ');
%  contorno = dlmread('FIG_3.dat',' '); 
%  Erro_Global = 30;%se mudar o erro, mudar a geracao dos caminhos
 
 arcos = calcula_arcos_rede(contorno);
 %caminhos = gera_caminhos(arcos,0.1*Erro_Global);
 caminhos = gera_caminhos(arcos,limiar);
  
 [dy,dx]= size(contorno);
 r = 0.4;%controle da distribuicao
 p = 0.1;%taxa evaporacao...
 alpha = 1;
 beta = 5;
 
 T = ones(1,dy);
 feromonio = ones(dy,dy)/dy; 
 tour_best = 1:dy;
 max_cycle = 50;
 total_ants = 20;

 Erro_Atual = Erro_Global;
 E = [];
 Erro_poligonal = [];
 nro_pontos = [];

 %cria as formigas...
 formigas = struct('inicio',0,'caminho',[]);
 formigas(1:total_ants) = formigas;
  
 for nc=1:max_cycle
     %disp(['Ciclo = ',int2str(nc)]);
     select = T/sum(T');
     tours = [];
     Erros = [];
     for ant=1:total_ants
         %zera caminho...
         formigas(ant).caminho = [];
         %selecionar no inicial...
         formigas(ant).inicio = sorteia_pos(select);
         
         %procurar caminho...
         last = formigas(ant).inicio;
         prox_no = 0;
         while (prox_no ~= formigas(ant).inicio)                        
             formigas(ant).caminho = [formigas(ant).caminho last];
             prox_no = procura_proximo_no(caminhos,contorno,formigas(ant).inicio,last,feromonio,alpha,beta);
             
             last = prox_no;
         end;
                 
         %guarda tamanho caminho...
         tours = [tours length(formigas(ant).caminho)];
         Erros = [Erros calculaErro(formigas(ant).caminho,arcos)];
     end;
     %analisar caminhos...
     
     for ant = 1:total_ants
         if Erros(ant) <= Erro_Global
             if tours(ant) <= length(tour_best)
                 Erro_Atual = Erros(ant);
                 tour_best = formigas(ant).caminho;
             end;
         end;
     end;
     
     %mostra o resultado atual...
     %desenha_caminho(contorno,tour_best,nc);
     %atualiza feromonio...
     feromonio = atualiza_feromonio(arcos,feromonio,formigas,contorno,Erro_Global,p);
     %atualiza T...
     T = atualiza_T(T,formigas,select,r);
     E = [E calcula_entropia(feromonio,caminhos,alpha,beta)];     
     Erro_poligonal = [Erro_poligonal calculaErro(tour_best,arcos)];
     nro_pontos = [nro_pontos length(tour_best)];
 end;

 caminho = tour_best;
 erro = calculaErro(tour_best,arcos);
 tam = length(tour_best);
 
%  figure(1);
%  desenha_caminho(contorno,tour_best,nc);
%  
%  figure(2);
%  plot(E); 
%  xlabel('Ciclos'); ylabel('Entropia');
% 
%  disp('Terminado');

%-----------------------------------------------------------------------
function novo_feromonio = atualiza_feromonio(arcos,feromonio,formigas,contorno,Erro_Global,p);
novo_feromonio = p * feromonio;
[dy,dx] = size(feromonio);
[n1,n2] = size(contorno);
soma = zeros(dy,dx);

for k=1:length(formigas)
    erro = calculaErro(formigas(k).caminho,arcos);
    s = length(formigas(k).caminho);
    
    for y=1:(s-1)
        
        if erro <= Erro_Global
            soma(formigas(k).caminho(y),formigas(k).caminho(y+1)) = ...
            soma(formigas(k).caminho(y),formigas(k).caminho(y+1)) + 1/s;
        else
            soma(formigas(k).caminho(y),formigas(k).caminho(y+1)) =...
            soma(formigas(k).caminho(y),formigas(k).caminho(y+1)) - erro/(Erro_Global*n1);
        end;                   
        
    end;
    
    if erro <= Erro_Global
        soma(formigas(k).caminho(s),formigas(k).caminho(1)) = ...
        soma(formigas(k).caminho(s),formigas(k).caminho(1)) + 1/s;
    else
        soma(formigas(k).caminho(s),formigas(k).caminho(1)) =...
        soma(formigas(k).caminho(s),formigas(k).caminho(1)) - erro/(Erro_Global*n1);
    end;                   
    
end;

c = find(soma < 0);
soma(c) = 0;

novo_feromonio = novo_feromonio + soma;

%-----------------------------------------------------------------------
function novo_T = atualiza_T(T,formigas,select,r);

for k=1:length(T)
    soma = 0;
    c = 0;
    
    for t=1:length(formigas)
        if formigas(t).inicio == k
            c = c + 1;
            soma = soma + 1/length(formigas(t).caminho);
        end;
    end;
    
    if c == 0
        novo_T(k) = T(k);
    else
        novo_T(k) = ((1-r)/c ) * soma + (r * select(k));    
    end;
end;

%-----------------------------------------------------------------------
function E = calcula_entropia(feromonio,caminhos,alpha,beta);
[dy,dx] = size(feromonio);
E = zeros(1,dy);

for pi=1:dy
    Tij = [];
    indice = [];    
    k = mod(pi,dy) + 1;
    
    while k~=pi
        if caminhos(pi,k)
            Tij = [Tij feromonio(pi,k)];
            indice = [indice k];
        end;        
        
        k = mod(k,dy) + 1;
    end;
        
    nij = indice - pi;
    c = find(nij <= 0);
    
    if length(c) ~= 0
        maior = max(nij');    
        nij(c) = pi + nij(c) + maior;
    end;
    
    Tij_A = Tij .^ alpha;
    nij_B = nij .^ beta;
    
    somatorio = sum(Tij_A .* nij_B);
    
    pij = (Tij_A .* nij_B)./somatorio;    
    E(pi) = -sum(pij.*log(pij));
end;

E = sum(E/dy);

%-----------------------------------------------------------------------
function caminhos = gera_caminhos(arcos,ErroGlobal);
[dy,dx]= size(arcos);
caminhos = zeros(dy,dy);
c = find(arcos < ErroGlobal);
caminhos(c) = 1;

for y = 1:dy
    caminhos(y,y) = 0;
end;
%-----------------------------------------------------------------------
function [X1,indices] = ordena_decrescente(X);
dim = length(X);
indices = 1:dim;

X1 = X;

for k=1:dim
    minimo = k;
    for m=k+1:dim
        if X1(m) > X1(minimo)
            minimo = m;
        end;
    end;
    
    temp = X1(k);
    X1(k) = X1(minimo);
    X1(minimo) = temp;
    
    temp = indices(k);
    indices(k) = indices(minimo);
    indices(minimo) = temp;
end;

%-----------------------------------------------------------------------
function pj = procura_proximo_no(caminhos,contorno,inicio,pi,feromonio,alpha,beta);

[dy,dx]= size(feromonio);
Tij = [];
indice = [];

k = mod(pi,dy) + 1;

while k~=inicio 
    if caminhos(pi,k)
        Tij = [Tij feromonio(pi,k)];
        indice = [indice k];
    end;        
    
    k = mod(k,dy) + 1;
end;

if caminhos(pi,inicio)
    Tij = [Tij feromonio(pi,inicio)];
    indice = [indice inicio];
end;

nij = indice - pi;
c = find(nij <= 0);

if length(c) ~= 0
    maior = max(nij');    
    nij(c) = pi + nij(c) + maior;
end;


Tij_A = Tij .^ alpha;
nij_B = nij .^ beta;

somatorio = sum(Tij_A .* nij_B);

pij = (Tij_A .* nij_B)./somatorio;

escolha = sorteia_pos(pij);
pj = indice(escolha);

%-----------------------------------------------------------------------
function ind = sorteia_pos(x);

y = rand;
[ordenado,indices] = ordena_decrescente(x);

infe = ordenado(1);
t=1;

while (y > infe)
    t = t +1;
    infe = infe + ordenado(t);    
end; 

ind = indices(t);