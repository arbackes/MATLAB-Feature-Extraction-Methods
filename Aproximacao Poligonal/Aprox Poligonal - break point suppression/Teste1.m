function cam = Teste1
close all;
clc;
% cromossomo...
% cam1 = [1,6,8,17,23,25,31,32,38,40,53,55];
% cam1 = [6,8,21,23,29,30,36,38,44,53,55,60];%novo sentido.

% curva = dlmread('FIG_3.dat',' ');
curva = dlmread('FIG_6.dat',' ');

curva = curva(end:-1:1,:);
L = length(curva);
max_erro = 30;

arcos = calcula_arcos_rede(curva);
cam = 1:length(curva);

rt = 0.7;

[cam,rem] = removePontos(curva,cam,0.1,1);

for dt=0.5:0.5:5
    pini = calculaInitialPoint(curva,cam);
    
    [Ncam,rem] = removePontos(curva,cam,dt,pini);
        
    comp = comprimentoAprox(curva,cam);    
    [er,max_er] = medeErro(curva,cam);
        
    if (length(Ncam) < length(cam)) && (max_er > 0)
        ri = comp / max_er;
        
        subplot(2,1,1); bar(cam,ri); hold on; plot(1:L,rt,'k-','linewidth',2); hold off;
        subplot(2,1,2); bar(cam(rem),ri(rem)); hold on; plot(1:L,rt,'k-','linewidth',2); hold off;
        pause(1);
        c = find(ri(rem) > rt);
        if (length(c) > 0)
            cam = sort([Ncam, cam(rem(c))]);
            break;
        end;
        
    end;
%     desenha(curva,Ncam);%teste...              
    cam = Ncam;
%     Nerro = calculaErro(Ncam,arcos);
%     if (Nerro < max_erro)        
%         cam = Ncam;        
%     end;
        
end;
    
erro = calculaErro(cam,arcos);
[er,max_er] = medeErro(curva,cam);

figure;
desenha(curva,cam);%teste...
title([num2str(erro),' -> ',int2str(length(cam))]);

disp(num2str(erro));
disp(num2str(max_er));

%=================================================
function [Ncam,rem] = removePontos(curva,cam,dt,pini)
rem = [];
continua = 1;
N = length(cam);
p1 = pini;%1;
p2 = mod(p1,N) + 1;%2;
p3 = mod(p2,N) + 1;%3;

%mudou = 0;
while continua    
    d1 = (curva(cam(p2),1) - curva(cam(p1),1)) * (curva(cam(p3),2) - curva(cam(p1),2));
    d2 = (curva(cam(p2),2) - curva(cam(p1),2)) * (curva(cam(p3),1) - curva(cam(p1),1));
    d3 = (curva(cam(p1),1) - curva(cam(p3),1))^2;
    d4 = (curva(cam(p1),2) - curva(cam(p3),2))^2;    
    d = sqrt(((d1 - d2)^2)/(d3 + d4));
    
%     if (d <= dt)
%         rem = [rem, p2];
%         p2 = p3;
%         p3 = mod(p3,N) + 1;
%     else
%         p1 = p2;
%         p2 = p3;
%         p3 = mod(p3,N) + 1;
%         %mudou = 1;
%     end;
%---------------------------------------
%TESTE
    if (d <= dt)
        rem = [rem, p2];
    else
        p1 = p2;                
    end;
    
    p2 = p3;
    p3 = mod(p3,N) + 1;
    while (length(find(p3 == rem)) ~= 0)
        p3 = mod(p3,N) + 1;
    end;        
%---------------------------------------

    if (p2 == pini) %if ((mudou == 1) && (pj == 1))
        continua = 0;
    end;    
end;

Ncam = cam;
Ncam(rem) = [];

%=================================================
function p = calculaInitialPoint(curva,cam)
p = 0;
maxD = 0;
p1 = 1;
p2 = 2;
p3 = 3;
N = length(cam);

for y=1:N    
    d1 = (curva(cam(p2),1) - curva(cam(p1),1)) * (curva(cam(p3),2) - curva(cam(p1),2));
    d2 = (curva(cam(p2),2) - curva(cam(p1),2)) * (curva(cam(p3),1) - curva(cam(p1),1));
    d3 = (curva(cam(p1),1) - curva(cam(p3),1))^2;
    d4 = (curva(cam(p1),2) - curva(cam(p3),2))^2;
    d = sqrt(((d1 - d2)^2)/(d3 + d4));
           
    if (d > maxD)
        maxD = d;
        p = p2;
    end;
        
    p1 = p2;
    p2 = p3;
    p3 = mod(p3,N) + 1;
end;

%=================================================
function max_er = medeErroRem(curva,cam)

max_er = 0;

N = length(cam);
for y=1:N
    cam1 = cam;
    cam1(y) = [];
    [er1,max_er1] = medeErro(curva,cam1);
    
    if (max_er1 > max_er)
        max_er = max_er1;
    end;
end;


%=================================================
function [er,max_er] = medeErro(curva,cam)

er = 0;
max_er = 0;
N = length(curva);
N1 = length(cam);

for y=1:N1
    p1 = y;
    p3 = mod(p1,N1) + 1;
    
    p1 = cam(p1);
    p3 = cam(p3);
    p2 = mod(p1,N) + 1;
    while (p2 ~= p3)                        
        d1 = (curva(p2,1) - curva(p1,1)) * (curva(p3,2) - curva(p1,2));
        d2 = (curva(p2,2) - curva(p1,2)) * (curva(p3,1) - curva(p1,1));
        d3 = (curva(p1,1) - curva(p3,1))^2;
        d4 = (curva(p1,2) - curva(p3,2))^2;
        d = ((d1 - d2)^2)/(d3 + d4);
        er = er + d;  
        p2 = mod(p2,N) + 1;
        
        if (d > max_er)
            max_er = d;
        end;
    end;
end;
max_er = sqrt(max_er);

%=================================================
function comp = comprimentoAprox(curva,cam)

comp = [];
p1 = 1;
p2 = 2;
p3 = 3;
N = length(cam);

for y=1:N    
    d12 = sqrt(sum((curva(cam(p2),1) - curva(cam(p1),1))^2 + (curva(cam(p2),2) - curva(cam(p1),2))^2));
    d23 = sqrt(sum((curva(cam(p3),1) - curva(cam(p2),1))^2 + (curva(cam(p3),2) - curva(cam(p2),2))^2));
    d13 = sqrt(sum((curva(cam(p3),1) - curva(cam(p1),1))^2 + (curva(cam(p3),2) - curva(cam(p1),2))^2));
    
    comp = [comp, (d12 + d23 - d13)];
    
    p1 = p2;
    p2 = p3;
    p3 = mod(p3,N) + 1;
end;

comp = [comp(end), comp(1:end-1)];
