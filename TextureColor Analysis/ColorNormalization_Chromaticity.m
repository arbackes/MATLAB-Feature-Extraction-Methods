function imP = ColorNormalization_Chromaticity(imO)
% imP = ColorNormalization_Chromaticity(imO)
% Calcula a normalização da imagem RGB usando Chromaticity
% 
% IMO: matriz [M x N x 3] contendo uma imagem RGB [0-255], no formato uint8
%
% IMP: matriz [M x N x 3] contendo uma imagem RGB normalizada [0-1], no 
% formato double
% 
% Paper:
% M. Ebner, Color Constancy, Wiley, England, 2007.

    imO = double(imO);
    RGB = sum(imO,3);
    imP = imO ./ repmat(RGB,[1 1 3]);
end