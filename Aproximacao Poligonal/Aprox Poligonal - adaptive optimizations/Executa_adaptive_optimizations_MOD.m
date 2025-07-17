% [NCAM,ERRO,TAM] = Executa_adaptive_optimizations(CURVA,MAX_ERRO)
% Calcula a aproximação poligonal de uma curva usando o método
% Adaptive Optimizations
% 
% Entrada:
% CURVA: matriz de N x 2, onde cada linha contém as coordenadas [x y] de
% um ponto do contorno
% MAX_ERRO: erro máximo (ISE) permitido 
% 
% Saída:
% NCAM: vetor contendo os índices selecionados da CURVA para compor 
% a aproximação poligonal
% ERRO: erro ISE da aproximação poligonal
% TAM: número de pontos selecionado para compor a aproximação poligonal
% 
% Paper: 
% Mohammad Tanvir Parvez and Sabri A. Mahmoud. Polygonal 
% approximation of digital planar curves through adaptive 
% optimizations. Pattern Recognition Letters, 31(13):1997-2005, 2010.

function [Ncam,erro,tam] = Executa_adaptive_optimizations_MOD(curva,max_erro)

arcos = calcula_arcos_rede(curva);

%Find all the break-points in the contour.
code = ChainCode(curva);
cam = removeCodeSequencia(code);
BreakPoints = cam;

%Find the set of cut-points by iterative suppression of redundant break-points using CCS.

%desenha(curva,cam);%teste...
dcol = 0.5;
continua = 1;
while (continua)
    Ncam = ReduceDominantPoints(cam,curva,dcol,max_erro,arcos);
    %erro = calculaErro(Ncam,arcos);
    if ((length(Ncam) == length(cam)) && (dcol > 2))
        Ncam = cam;
        break;
    end;
    dcol = dcol + 0.5;
    cam = Ncam;
    %desenha(curva,cam);
end;

%3.4. Adaptive optimizations
% dlimit = dcol - 0.5;
%Ncam = LocalOptimization(Ncam,curva,dlimit);% Tem que resolver isso ainda..

erro = calculaErro(Ncam,arcos);
tam = length(Ncam);


%desenha(curva,cam);%teste...

%=================================================
function desenha(curva,cam)

plot(curva(:,1),-curva(:,2),'b-'); hold on;
plot(curva(cam,1),-curva(cam,2),'o'); hold off
title(int2str(length(cam)));
pause(1);

%=================================================
function Ncam = LocalOptimization(cam,curva,dlimit)
dcol = 1.0;
while (dcol <= dlimit)
    Ncam = ReduceDominantPoints(cam,curva,dcol);
    cam = Ncam;
    dcol = dcol + 0.5;    
    desenha(curva,cam);
end;

%=================================================
function s = calculaStrength(cam,N)
N1 = length(cam);
s = zeros(1,N1);

ant = N1;
next = 2;
for y=1:N1
    c = 0;
    p = cam(ant);
    while (p ~= cam(next))
        c = c + 1;
        p = mod(p,N) + 1;
    end;
    
    s(y) = c;
    next = mod(next,N1) + 1;
    ant = mod(ant,N1) + 1;
end;

function [sord,ind] = ordenaStrength(s,curva,cam)

[sord,ind] = sort(s);
%calcula distância até o centroide de C
N1 = length(cam);
d = zeros(1,N1);
med = mean(curva);
for y=1:N1
    d(y) = sqrt(sum((curva(cam(y),:) - med(1,:)).^2));
end;
d = d(ind);

%reordenar segundo a segunda coluna
v = [sord',d',ind'];

menor = min(v(:,1));
maior = max(v(:,1)) + 1;

while (menor < maior)
    sel = find(v(:,1) == menor);    
    [v1,ind1] = sort(v(sel,2));    
    v(sel,:) = v(sel(ind1),:);
    v(sel,1) = maior;
    menor = min(v(:,1));
end;

sord = v(:,1);
ind = v(:,3);


function d = DistanciaPerpendicular(p1,p2,p3)

d1 = (p2(1) - p1(1)) * (p3(2) - p1(2));
d2 = (p2(2) - p1(2)) * (p3(1) - p1(1));
d3 = (p1(1) - p3(1))^2;
d4 = (p1(2) - p3(2))^2;

d = sqrt(((d1 - d2)^2)/(d3 + d4));

%=================================================
function res = checkUnsuppressedDominantPoint(curva,cam,p1,p2,p3,dcol)
N = length(cam);
res = 1;

p = p1;
while (p ~= p3)    
    if ((p ~= p1) && (p ~= p2) && (p ~= p3))
        dper = DistanciaPerpendicular(curva(cam(p1),:),curva(cam(y),:),curva(cam(p3),:));
        if (dper < dcol)
            res = 0;
            break;
        end;
    end;    
    p = mod(p,N) + 1;
end;

if (res)
    while (p ~= p1)    
        if ((p ~= p1) && (p ~= p2) && (p ~= p3))
            d1 = sqrt(sum((curva(cam(p1),:) - curva(cam(p),:)).^2));
            d2 = sqrt(sum((curva(cam(p2),:) - curva(cam(p),:)).^2));
            dper = min([d1 d2]);
            
            if (dper < dcol)
                res = 0;
                break;    
            end;    
        end;
        p = mod(p,N) + 1;
    end;
end;

%=================================================
function Ncam = ReduceDominantPoints(cam,curva,dcol,max_erro,arcos)
N = length(curva);
N1 = length(cam);
Ncam = cam;

continua = 1;
while continua
    continua = 0;
    st = calculaStrength(Ncam,N);
    [v,ind] = ordenaStrength(st,curva,cam);
    %[v,ind] = sort(st);
    
    for y=1:N1
        pj = ind(y);
        
        pi = pj - 1;
        if (pi < 1)
            pi = N1;
        end;
        
        pk = pj + 1;
        if (pk > N1)
            pk = 1;
        end;
        
        dper = DistanciaPerpendicular(curva(Ncam(pi),:),curva(Ncam(pj),:),curva(Ncam(pk),:));
        if (dper < dcol)
            if (IsTriangleAcute(curva(Ncam(pi),:),curva(Ncam(pj),:),curva(Ncam(pk),:)))
                if(checkUnsuppressedDominantPoint(curva,Ncam,pi,pj,pk,dcol))
                    
                    cam1 = Ncam;
                    cam1(pj) = [];
                    er = calculaErro(cam1,arcos);
                    if (er < max_erro)
                        Ncam(pj) = [];
                        N1 = N1 - 1;
                        continua = 1;
                        break;
                    end;
                end;
            end;
        end;
    end;
    
end;

%=================================================
function res = IsTriangleAcute(p1,p2,p3)
%Os angulos que não sejam do ponto a ser removido devem ser agudos
d12 =  sqrt(sum((p1 - p2).^2));
d13 =  sqrt(sum((p1 - p3).^2));
d23 =  sqrt(sum((p2 - p3).^2));

ang1 = acos(((d23 * d23) - (d12 * d12) - (d13 * d13)) / (-2 * d12 * d13));
%ang2 = acos(((d13 * d13) - (d12 * d12) - (d23 * d23)) / (-2 * d12 * d23));
ang3 = acos(((d12 * d12) - (d13 * d13) - (d23 * d23)) / (-2 * d13 * d23));

pi2 = pi/2;

%res = (ang1 < pi2) && (ang2 < pi2) && (ang3 < pi2);
res = (ang1 < pi2) && (ang3 < pi2);

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

% p(1) = curva(N,1) - curva(1,1);
% p(2) = curva(N,2) - curva(1,2);
p(1) = curva(1,1) - curva(N,1);
p(2) = curva(1,2) - curva(N,2);

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
