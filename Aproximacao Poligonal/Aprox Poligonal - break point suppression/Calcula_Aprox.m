clc;
clear all;
close all;

% curva = dlmread('FIG_3.dat',' ');%chromosome
% curva = dlmread('FIG_4.dat',' ');%leaf
curva = dlmread('FIG_6.dat',' ');%semicircle

result = [];

% for max_erro = [30 20 10 8 6]
% for max_erro = [150 100 90 30 15]
for max_erro = [60 30 25 20 15]
    old_erro = 0.0;
    
    for rt = 0.1:0.025:2.0
        [cam,erro,tam]= Executa_break_point_suppression(curva,rt,max_erro);
        if (erro ~= old_erro)
            old_erro = erro;
            result = [result; rt, tam, erro, max_erro];
        end;    
    end;
end;
