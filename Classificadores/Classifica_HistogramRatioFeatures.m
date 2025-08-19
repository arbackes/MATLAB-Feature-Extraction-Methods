function cla = Classifica_HistogramRatioFeatures(B,C,classes)
% B e C sao Cell Vectors
% Classifica um conjunto de Histogram Ratio Features usando a abordagem 
% leave-one-out.
% 
% CLA = Classifica_HistogramRatioFeatures(B,C,CL)
% 
% B: Cell vector de [1 x N] ou [N x 1] contendo os indices dos principais 
% bins do histograma 1D colorido obtidos para cada imagem.
% C: Cell vector de [1 x N] ou [N x 1] contendo os valores dos principais 
% bins do histograma 1D colorido.
% CL: vetor de [1 x N] ou [N x 1] contendo a classe de cada amostra.
% 
% CLA: vetor de [1 x N] ou [N x 1] contendo a classe em que cada amostra 
% foi classificada.
% 
% Ex:
% arq = dir([pasta,'*.png']);
% for x=1:length(arq)
%     I = imread([pasta,arq(x).name]);
%     [B1 C1] = histogramRatio(I);
%     B{x} = B1;
%     C{x} = C1;
% end;
% cla = Classifica_HistogramRatioFeatures(B,C,classes);
% 
% Paper:
% G. Paschos, M. Petrou, Histogram ratio features for color texture 
% classification, Pattern Recognition Letters 24 (2003) 309–314.

N = length(classes);
maxC = max(classes);
ind = 1:N;
cla = zeros(1,N);
for y=1:N
    RSample = RatioFeatures_Sample(B{y},C{y});    
    maxD = 0;    
    sel = 0;
    for x=1:maxC
        t = find(ind ~= y);
        t1 = find(classes(t) == x);
        RClass = RatioFeatures_Class(B(t(t1)),C(t(t1)));
        D = ComparaFeatures_SampleClass(RClass,RSample);
        if (D > maxD)
            sel = x;
            maxD = D;
        end;
    end;
    
    cla(y) = sel;
end;

%==========================================================================
function D = ComparaFeatures_SampleClass(RClass,RSample)
%Calcula a distância do "Histogram ratio feature" de uma amostra para uma classe.
Nc = size(RClass,1);
Ns = size(RSample,1);
D = 0;
for y=1:Ns
    for x=1:Nc
        if ((RClass(x,1) == RSample(y,1)) && (RClass(x,2) == RSample(y,2)))
            if ((RClass(x,3) <= RSample(y,3)) && (RClass(x,4) >= RSample(y,3)))
                D = D + 1;                
            end;
        end;
        
        if (RClass(x,1) > RSample(y,1))
            break;
        end;
    end;
end;

%==========================================================================
function R = RatioFeatures_Sample(B,C)
%Calcula o "Histogram ratio feature" de uma amostra.

tam = length(B); 
R = [];
for x=1:tam 
    for y=x+1:tam
        R = [R; B(x) B(y) (C(x)/C(y))];
    end;
end;

%==========================================================================
function R = RatioFeatures_Class(B,C)
% Calcula o "Histogram ratio feature" de uma classe contendo M amostras.
% B e C sao Cell Vectors
M = length(B);
B1 = B{1};
for y=2:M
    [B1,i1,i2] = intersect(B1,B{y});
end;

Bi = B1;
Ci = [];
for y=1:M
    [B1,i1,i2] = intersect(Bi,B{y});
    C1 = C{y};
    Ci = [Ci; C1(i2)];    
end;

tam = length(Bi);
R = [];
% combinação par a par de cada elemento
for x=1:tam
    for y=x+1:tam
        %divide todos por todos para achar o menor
        % e o maior ratio
        Rtemp = Ci(:,x) ./ Ci(:,y);
        R = [R; Bi(x) Bi(y) min(Rtemp) max(Rtemp)];
    end
end