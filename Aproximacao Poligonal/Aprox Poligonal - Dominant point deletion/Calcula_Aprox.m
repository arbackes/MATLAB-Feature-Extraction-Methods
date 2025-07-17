clc;
clear all;
close all;

curva = dlmread('..\Curvas\FIG_6.dat',' ');
result = [];

for max_erro = [30 20 10 8 6]
% for max_erro = [150 100 90 30 15]
% for max_erro = [60 30 25 20 15]
    [cam,erro,tam] = Executa_dominant_point_deletion(curva,max_erro);
    result = [result; tam, erro, max_erro];
end;
