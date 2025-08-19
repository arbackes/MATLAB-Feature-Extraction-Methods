function [B,C] = TextureColor_HistogramRatioFeatures(I)
% Calcula o histograma 1D colorido de uma imagem RGB, depois de converte-la
% para o espaco xyY. Este histograma eh entao utilizado para calcular
% descritores baseados nas relações entre os bins do histograma.
% 
% [B,C] = TextureColor_HistogramRatioFeatures(IM)
% IM: matriz [N x N] contendo uma imagem colorida RGB [0-255], no 
% formato double.
% 
% B: vetor linha contendo os indices do principais bins do histograma 1D
% colorido.
% C: vetor linha contendo os valores do principais bins do histograma 1D
% colorido.
% 
% Ex:
% arq = dir([pasta,'*.png']);
% for x=1:length(arq)
%     I = imread([pasta,arq(x).name]);
%     [B1 C1] = TextureColor_HistogramRatioFeatures(I);
%     B{x} = B1;
%     C{x} = C1;
% end;
% cla = Classifica_HistogramRatioFeatures(B,C,classes);
% 
% Paper:
% G. Paschos, M. Petrou, Histogram ratio features for color texture 
% classification, Pattern Recognition Letters 24 (2003) 309–314.

    Q = 100;    
    I = double(I);
    
    %% transformação para xyY
    X = 0.607*I(:,:,1) + 0.174*I(:,:,2) + 0.200*I(:,:,3);
    Y = 0.299*I(:,:,1) + 0.587*I(:,:,2) + 0.114*I(:,:,3);
    Z = 0.066*I(:,:,2) + 1.111*I(:,:,3);
    
    x = X ./ (X + Y + Z);
    y = Y ./ (X + Y + Z);
    Y = Y ./ max(Y(:));
    
    %% discretizando para facilitar calculos    
    x = x*100; x = round(x); %x = x/100;
    y = y*100; y = round(y); %y = y/100;
    Y = Y*100; Y = round(Y); %Y = Y/100;
%     x = I(:,:,1);
%     y = I(:,:,2);
%     Y = I(:,:,3);
    
    %% montando indices do histograma
    res = 5;
    %t_count=res_val*floor(col_array_vals(:,:,1)/res_val)+256*(res_val*floor(col_array_vals(:,:,2)/res_val))+256*256*(res_val*floor(col_array_vals(:,:,3)/res_val));
    indices = res*floor(x/res) + res*floor(y/res).*Q + res*floor(Y/res).*(Q^2);
    [C,B] = hist(indices(:),unique(indices)); B = B';
%     bar(1:length(B),C); 
        
    %% selecionar os bins com valor >= a 0.1% (0.1/100)
    [nx,ny,nz] = size(I);
    c = find(C < (nx * ny * 0.001));
    B(c) = [];
    C(c) = [];