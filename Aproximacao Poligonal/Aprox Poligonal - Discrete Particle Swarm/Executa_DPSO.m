clc;
clear all;
close all;

% contorno = dlmread('..\Curvas\FIG_3.dat',' '); Erro = [30 20 10 8 6]; %chromossome
contorno = dlmread('..\Curvas\FIG_4.dat',' '); Erro = [150 100 90 30 15]; %leaf
% contorno = dlmread('..\Curvas\FIG_6.dat',' '); Erro = [60 30 25 20 15]; %semicircle

res = [];
for er = [15]
    for y=1:10        
        [caminho,erro,tam] = DPSO(contorno,er);
        res = [res; tam, erro, er];        
    end;     
end;       


%Teste Split-Merge
% arcos = calcula_arcos_rede(contorno);
% melhor_caminho = Executa_split_merge(contorno,arcos,caminho,Erro)
% erro = calculaErro(melhor_caminho,arcos)