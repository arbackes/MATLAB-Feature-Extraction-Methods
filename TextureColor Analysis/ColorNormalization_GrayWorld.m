function imP = ColorNormalization_GrayWorld(imO)
% imP = ColorNormalization_GrayWorld(imO)
% Calcula a normalização da imagem RGB usando GrayWorld Normalization
% 
% IMO: matriz [M x N x 3] contendo uma imagem RGB [0-255], no formato uint8
%
% IMP: matriz [M x N x 3] contendo uma imagem RGB normalizada no 
% formato double (os valores podem não estar no intervalo [0-1])
% 
% Paper:
% M. Ebner, Color Constancy, Wiley, England, 2007.

    imO = double(imO);
    imP = zeros(size(imO));
    for y=1:3
        imP(:,:,y) = imO(:,:,y) / mean2(imO(:,:,y));
    end
end