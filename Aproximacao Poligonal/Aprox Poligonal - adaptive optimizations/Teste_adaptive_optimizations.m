clc;
clear all;
close all;

% contorno = dlmread('..\Curvas\FIG_3.dat',' ');%chromossome
% melhor_caminho = [7 25 31 39 54 60]; Erro = 30;%OK
% melhor_caminho = [40 54 60 7 13 25 32 38]; Erro = 20;%OK %melhorar
% melhor_caminho = [37 40 54 60 6 7 17 23 25 32]; Erro = 10;%OK
% melhor_caminho = [32 38 40 53 55 60 5 7 15 24 26]; Erro = 8;%OK
% melhor_caminho = [1 5 7 17 23 26 32 38 40 53 55 59]; Erro = 6;%OK

% contorno = dlmread('..\Curvas\FIG_4.dat',' ');%leaf
% melhor_caminho = [58 63 88 103 110 6 28 35 39]; Erro = 150;
% melhor_caminho = [115 120 10 27 35 40 50 66 88 103 109]; Erro = 100;
% melhor_caminho = [40 47 53 64 88 103 109 115 1 11 26 35]; Erro = 90;%OK
% melhor_caminho = [48 53 64 76 89 103 109 115 120 9 12 17 21 26 35 40]; Erro = 30;%OK
% melhor_caminho = [35 40 48 52 58 63 75 77 87 91 95 103 109 115 120 7 12 17 21 27]; Erro = 15;%OK

contorno = dlmread('..\Curvas\FIG_6.dat',' ');%semicircle
% melhor_caminho = [32 39 48 56 65 71 87 96 5 14]; Erro = 60;%OK
% melhor_caminho = [37 40 46 50 56 65 71 87 96 5 14 31]; Erro = 30;
% melhor_caminho = [37 40 46 51 57 63 69 73 90 99 8 14 31]; Erro = 25;
% melhor_caminho = [93 99  8 14 31 35 40 46 51 57 63 69 73 90]; Erro = 20;
% melhor_caminho = [45 48 54 58 64 69 73 79 90 96 1 8 14 25 31 35 41]; Erro = 15;%OK

%contorno = contorno(end:-1:1,:);
% [cam,erro,tam] = Executa_adaptive_optimizations(contorno,Erro)

%[cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,Erro);

dados = [];
[cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,60); dados = [dados; length(cam) erro];
[cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,30); dados = [dados; length(cam) erro];
[cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,25); dados = [dados; length(cam) erro];
[cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,20); dados = [dados; length(cam) erro];
[cam,erro,tam] = Executa_adaptive_optimizations_MOD(contorno,15); dados = [dados; length(cam) erro];