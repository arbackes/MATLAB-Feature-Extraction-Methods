clc;
clear all;
close all;

% contorno = dlmread('..\Curvas\FIG_3.dat',' '); Erro = [30 20 10 8 6]; %chromossome
% contorno = dlmread('..\Curvas\FIG_4.dat',' '); Erro = [150 100 90 30 15]; %leaf
contorno = dlmread('..\Curvas\FIG_6.dat',' '); Erro = [60 30 25 20 15]; %semicircle

res = [];
for er = [20 15]
    for y=1:10        
        [caminho,erro,tam] = ACS(contorno,er,0.1*er);
        res = [res; tam, erro, er];        
    end;     
end;       

%  contorno = dlmread('girl.dat',' ');
% %  contorno = dlmread('FIG_3.dat',' '); 
%  Erro_Global = 400;%se mudar o erro, mudar a geracao dos caminhos
% 
% [caminho,erro,tam] = ACS(contorno,Erro_Global);

%Teste Split-Merge
% arcos = calcula_arcos_rede(contorno);
% melhor_caminho = Executa_split_merge(contorno,arcos,caminho,Erro)
% erro = calculaErro(melhor_caminho,arcos)