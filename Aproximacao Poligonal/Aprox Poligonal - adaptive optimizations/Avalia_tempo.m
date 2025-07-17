clc;
clear all;
close all;

tempos = [0 0 0];
%%
% contorno = dlmread('..\Mpeg7\camel-01.ctn',' '); Erro = 400; contorno = contorno(1:3:end,:);
contorno = dlmread('..\Curvas\FIG_3.dat',' '); Erro = 30; %chromossome
m = sum(contorno);
c = find(m == 0);
contorno(:,c) = [];

m = [];
for y=1:10
    tic;
%     [caminho,erro,tam] = VertexBetweeness_AproxPoligonal(contorno,Erro,0.3*Erro);
    [cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,Erro);    
    %[caminho,erro,tam] = ACS(contorno,Erro,0.1*Erro);
    %[cam,erro,tam]= Executa_break_point_suppression(contorno,0.5,Erro);
    %[caminho,erro,tam] = DPSO(contorno,Erro);
%     [cam,erro,tam] = Executa_dominant_point_deletion(contorno,Erro);
    t = toc;
    m = [m, t];
end;
tempos(1) = mean(m);

%%
%contorno = dlmread('..\Mpeg7\dog-01.ctn',' '); Erro = 1500; contorno = contorno(1:4:end,:);
contorno = dlmread('..\Curvas\FIG_4.dat',' '); Erro = 150;%leaf
m = sum(contorno);
c = find(m == 0);
contorno(:,c) = [];

m = [];
for y=1:10
    tic;
%     [caminho,erro,tam] = VertexBetweeness_AproxPoligonal(contorno,Erro,0.3*Erro);
    [cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,Erro);    
    %[caminho,erro,tam] = ACS(contorno,Erro,0.1*Erro);
    %[cam,erro,tam]= Executa_break_point_suppression(contorno,0.5,Erro);
    %[caminho,erro,tam] = DPSO(contorno,Erro);
%     [cam,erro,tam] = Executa_dominant_point_deletion(contorno,Erro);
    t = toc;
    m = [m, t];
end;
tempos(2) = mean(m);

%%
% contorno = dlmread('..\Mpeg7\bat-02.ctn',' '); Erro = 800; contorno = contorno(1:4:end,:);
contorno = dlmread('..\Curvas\FIG_6.dat',' '); Erro = 60;%semicircle
m = sum(contorno);
c = find(m == 0);
contorno(:,c) = [];

m = [];
for y=1:10
    tic;
%     [caminho,erro,tam] = VertexBetweeness_AproxPoligonal(contorno,Erro,0.3*Erro);
    [cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,Erro);    
    %[caminho,erro,tam] = ACS(contorno,Erro,0.1*Erro);
    %[cam,erro,tam]= Executa_break_point_suppression(contorno,0.5,Erro);
    %[caminho,erro,tam] = DPSO(contorno,Erro);
%     [cam,erro,tam] = Executa_dominant_point_deletion(contorno,Erro);
    t = toc;
    m = [m, t];
end;
tempos(3) = mean(m);
%%

%Metodo     Camel   Dog         Bat
%VertexB    8.7843  19.1575     9.0690