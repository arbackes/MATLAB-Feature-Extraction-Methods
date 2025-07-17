% [CAM,ERRO,TAM] = Executa_dominant_point_deletion(CURVA,MAX_ERRO)
% Calcula a aproximação poligonal de uma curva usando o método
% Dominant Point Deletion (DPD)
% 
% Entrada:
% CURVA: matriz de N x 2, onde cada linha contém as coordenadas 
% [x y] de um ponto do contorno
% MAX_ERRO: erro máximo (ISE) permitido para a aproximação poligonal
% 
% Saída:
% CAM: vetor contendo os índices selecionados da CURVA para 
% compor a aproximação poligonal
% ERRO: erro ISE da aproximação poligonal
% TAM: número de pontos selecionado para compor a aproximação poligonal
% 
% Paper: 
% A. Masood. Optimized polygonal approximation by dominant point 
% deletion. Pattern Recognition, 41(1):227-239, 2008.

function [cam,erro,tam] = Executa_dominant_point_deletion(curva,max_erro)

arcos = calcula_arcos_rede(curva);

code = ChainCode(curva);
cam = removeCodeSequencia(code);
AEV = calculaAEV(cam,arcos);

erro = calculaErro(cam,arcos);
continua = 1;

% desenha(curva,cam);%teste...

while (continua)
    %remove menor ponto com menor AEV...
    sel = find(AEV == min(AEV));
    sel = sel(1); %caso exista mais de um, escolher o primeiro.
%     if (length(cam) == 14)
%         disp('ok');
%     end;
    Ncam = otimizaAproxPoligonal(cam,arcos,sel,length(curva));    
    Nerro = calculaErro(Ncam,arcos);
    
    %desenha(curva,Ncam);%teste...    
        
    if (Nerro < max_erro)
        erro = Nerro;
        cam = Ncam;
        AEV = calculaAEV(cam,arcos);
    else
        continua = 0;        
    end;
    
end;

erro = calculaErro(cam,arcos);
tam = length(cam);
%desenha(curva,cam);%teste...

%=================================================
function desenha(curva,cam)

plot(curva(:,1),curva(:,2)); hold on;
plot(curva(cam,1),curva(cam,2),'o'); hold off
title(int2str(length(cam)));
pause(1);

%=================================================
function code = ChainCode(curva)

mat = [3 2 1; 4 -1 0; 5 6 7];
%mat = [5 6 7; 4 -1 0; 3 2 1];
N = length(curva);
code = [];

for y=1:N-1    
    p(1) = curva(y+1,1) - curva(y,1);
    p(2) = curva(y+1,2) - curva(y,2);
    
    for x=1:2
        if (p(x) ~= 0)
            p(x) = p(x) / abs(p(x));
        end;
    end;    
    
    code = [code, mat(p(2)+2,p(1)+2)];
end;

p(1) = curva(N,1) - curva(1,1);
p(2) = curva(N,2) - curva(1,2);

for x=1:2
    if (p(x) ~= 0)
        p(x) = p(x) / abs(p(x));
    end;
end;    
code = [code, mat(p(2)+2,p(1)+2)];

%=================================================
function nonRep = removeCodeSequencia(code)

N = length(code);
nonRep = zeros(1,N);

for y=2:N
    if (code(y) ~= code(y-1))
        nonRep(y) = 1;
    end;
end;

if (code(1) ~= code(N))
    nonRep(1) = 1;
end;

nonRep = find(nonRep == 1);

%=================================================
function AEV = calculaAEV(nonRep,arcos);

N = length(nonRep);
AEV = [];
erro = calculaErro(nonRep,arcos);

for y=1:N
    cam = nonRep;
    cam(y) = [];
    er = calculaErro(cam,arcos);
    AEV = [AEV, (er - erro)];    
end;

%=================================================
function Ncam = otimizaAproxPoligonal(cam,arcos,sel,N)

Vsel = cam(sel);
Ncam = cam;
Ncam(sel) = [];
[pant,pnext] = BuscaAntNext(sel,Vsel,Ncam,N);

lista = [pant,pnext];
Viz_next = [2:length(Ncam), 1];
Viz_ant = [length(Ncam), 1:length(Ncam)-1];

while (length(lista) ~= 0)
    p = lista(1);
    lista(1) = [];
    
    OrigValue = Ncam(p);
    OldValue = Ncam(p);
    OldErro = calculaErro(Ncam,arcos);
    
    Vant = Ncam(Viz_ant(p));
    Vant = mod(Vant,N) + 1;
    Vnext = Ncam(Viz_next(p));
    mudou = 0;
    while (Vant ~= Vnext)
        Ncam(p) = Vant;
        erro = calculaErro(Ncam,arcos);
        if (erro < OldErro)
            OldErro = erro;
            OldValue = Vant;
        end;
        
        Vant = mod(Vant,N) + 1;
    end;  
    
    Ncam(p) = OldValue;
    if (OrigValue ~= OldValue)
        lista = [Viz_ant(p), Viz_next(p), lista];
    end;
end;

%=================================================
function [pant,pnext] = BuscaAntNext(sel,Vsel,Ncam,Ncurva)

N = length(Ncam);
if ((sel == 1) || (sel > N))
    pant = N;
    pnext = 1;    
else
    pant = 1;
    pnext = 2;
    
    %while ~((Ncam(pant) < Vsel) && (Vsel < Ncam(pnext)))
    while ~procuraValor(Ncam(pant),Ncam(pnext),Vsel,Ncurva)
        pant = pnext;
        pnext = mod(pnext,N) + 1;
    end;    
end;

%=================================================
function achou = procuraValor(vini,vfim,valor,N)

v = mod(vini,N) + 1;
achou = 0;

while (v ~= vfim)
    if (v == valor)
        achou = 1;
        break;
    else
        v = mod(v,N) + 1;
    end;
end;