function imC = converteRGB2Colormap(im,mapaColorT)
% IMC = converteRGB2Colormap(IM,MAPACOLORT)
% Converte uma imagem RGB para uma imagem indexada de acordo com uma tabela
% de cores.
% 
% IM: matriz [N x N] contendo uma imagem colorida RGB [0-255].
% 
% MAPACOLORT: matriz [256 x 256 x 256] contendo o indice de cada cor do
% espaço RGB de acordo com uma tabela de cores previamente estipulada.
% 
% IMC: matriz [N x N] contendo os indices das cores contidas em uma 
% MAPACOLORT.
% 
% Ex:
% he = imread('hestain.png');
% imshow(he);
% [colorT,mapaColorT] = colorTable(2);
% heC = converteRGB2Colormap(he,mapaColorT);
% figure; imagesc(heC)

[ny,nx,nz] = size(im);
imC = zeros(ny,nx);

for y=1:ny
    for x=1:nx
        imC(y,x) = mapaColorT(im(y,x,1)+1,im(y,x,2)+1,im(y,x,3)+1);
    end;
end;