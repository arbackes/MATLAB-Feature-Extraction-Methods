% [Y,W] = Calcula_ICA(X)
% Independent Component Analysis(ICA) using PCA
% 
% Calcula os componentes independentes dos dados X usando o P-ICA linear
%
% Entrada: 
% X: é uma matriz de misturas (N x D, N amostras com D descritores cada)
%
% Y: é a matriz com os sinais estimados (N x D, N amostras com D
% descritores cada)
% W: é a matriz de mistura (inversa de A) (opcional)
%
% Exemplos:
% y = Calcula_ICA(x); % calcula apenas os componentes independentes
% [y,w] = Calcula_ICA(x); % calcula os componentes independentes e a matriz de
% mistura
%
% A. Hyvarinen and E. Oja, Independent Component Analysis, Algorithms and 
% Applications, Neural Networks, 13(4-5):411-430, 2000
% 
% Autor: Nielsen C. Damasceno
% Data: 20.12.2010

function [y,w] = Calcula_ICA(x)
    x = x';% descritores precisam estar nas linhas 
    N = size(x,1);
    for k=1:N
        x(k,:) = x(k,:) - mean(x(k,:));
    end
    n = size(x,1);
    [E, D] = eig(cov(x'));
    v = E*D^(-0.5)*E'*x;
    z = repmat(sqrt(sum(v.^2)),n,1).*v;
    [EE, DD] = eig(z*z');
    y = EE'*v;
    w = EE';
    y = y';
end