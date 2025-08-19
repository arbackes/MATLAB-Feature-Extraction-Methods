% function di = Distance_CCM(ccm1,ccm2,tipo)
% Calcula a distância entre dois conjuntos de matrizes de co-ocorrência
% calculadas usando o método Chromatic co-occurrence matrices (CCM)
% 
% CCM1 e CCM2: struct contendo 6 campos. Cada campo representa a matriz de 
% co-ocorrência de cores entre canais usando o método de 
% Chromatic co-occurrence matrices (CCM).
% TIPO: tipo de métrica usada no cálculo da diferença das matrizes
%  - TIPO = 1: Intersection between CCMs. Imagens são similares se o valor
%  está próximo de 1.
%  - TIPO = 2: Jeffrey Divergence between CCMs. Imagens são similares se o 
% valor está próximo de 0.
% 
% Paper:
% CCM_JeffreyDivergence
% Y.Rubner, J.Puzicha, C.Tomasi, J.M.Buhmann, Empirical evaluation of
% dissimilarity measures for color and texture, Computer Vision and Image
% Understanding 84(1)(2001) 25–43.
% 
% CCM_Intersection
% T.Mäenpää, M.Pietikäinen, Classification with color and texture: jointly 
% or separately?, Pattern Recognition 37(8)(2004) 1629–1640


function di = Distance_CCM(ccm1,ccm2,tipo)
    switch tipo
        case 0
            di = CCM_Intersection(ccm1,ccm2);
        case 1
            di = CCM_JeffreyDivergence(ccm1,ccm2);
        otherwise
            di = Inf;
    end

end

%% ========================================================================
% When the two images share a similar spatial arrangement of colors,
% their similarity measure value SIM is close to 1. Although it does not 
% necessarily mean that the two images contain the same texture, we 
% assume so. On the otherhand, a similarity measure value close to 0 means 
% that the two textures are significantly different
function di = CCM_Intersection(ccm1,ccm2)
    di = CCM_Intersection_Diff(ccm1.RR,ccm2.RR);
    di = di + CCM_Intersection_Diff(ccm1.GG,ccm2.GG);
    di = di + CCM_Intersection_Diff(ccm1.BB,ccm2.BB);
    di = di + CCM_Intersection_Diff(ccm1.RG,ccm2.RG);
    di = di + CCM_Intersection_Diff(ccm1.RB,ccm2.RB);
    di = di + CCM_Intersection_Diff(ccm1.GB,ccm2.GB);
    di = di / 6.0;    
end

function di = CCM_Intersection_Diff(m1,m2)
    di = min(m1,m2);
    di = sum(di(:));
end

%% ========================================================================
% When thet wo images contain the same texture, the Jeffrey divergence 
% between their CCMs is close to 0, where as it tends to infinity when 
% they are quite different
function di = CCM_JeffreyDivergence(ccm1,ccm2)
    di = CCM_JeffreyDivergence_Diff(ccm1.RR,ccm2.RR);
    di = di + CCM_JeffreyDivergence_Diff(ccm1.GG,ccm2.GG);
    di = di + CCM_JeffreyDivergence_Diff(ccm1.BB,ccm2.BB);
    di = di + CCM_JeffreyDivergence_Diff(ccm1.RG,ccm2.RG);
    di = di + CCM_JeffreyDivergence_Diff(ccm1.RB,ccm2.RB);
    di = di + CCM_JeffreyDivergence_Diff(ccm1.GB,ccm2.GB);
    di = di / 6.0;  
end

function di = CCM_JeffreyDivergence_Diff(m1,m2)
    m = (m1 + m2) / 2.0;

    mA = zeros(size(m1));
    c = find(m1 > 0 & m > 0);
    mA(c) = m1(c) .* log(m1(c)./m(c));
    
    mB = zeros(size(m2));
    c = find(m2 > 0 & m > 0);
    mB(c) = m2(c) .* log(m2(c)./m(c));
    
    di = mA + mB;
    di = sum(di(:));    
end