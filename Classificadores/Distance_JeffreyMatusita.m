function [JM,JMAll] = Distance_JeffreyMatusita(data,classes)
% Distancia Jeffrey-Matusita
% [JM,JMAll] = Distance_JeffreyMatusita(data,classes)
% A distancia Jeffrey-Matusita mede a separabilidade entre duas classes de 
% dados. Seu calculo depende da distancia de Battacharyya distance
% 
% data: matriz [N x M] contendo os vetores de caracteristicas de cada
% elemento.
% classes: array de [N x 1] ou [1 x N] contendo a classe da cada elemento
% 
% JM: matriz [K x K] contendo a distancia Jeffrey-Matusita entre cada duas 
% classes, onde K é o numero de classes em data
% JMAll: Soma normalizada entre [0,1] das distancias de Jeffrey-Matusita 
% entre todas as classes de dados.

B = Distance_Bhattacharyya(data,classes);

JM = sqrt(2 * (1 - exp(-B)));

n = max(classes);

bn = nchoosek(n,2);

JMAll = (sum(JM(:))/2) / (sqrt(2) * bn);