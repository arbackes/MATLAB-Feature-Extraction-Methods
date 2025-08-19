function desc = TextureColor_GaborFilter_EEE(img,escalas,orientacao,varargin)
% DESC = TextureColor_GaborFilter_EEE(IMG,ESCALAS,ORIENTACOES,[FR_MENOR FR_MAIOR])
% O Filtro de Gabor 2-D e, basicamente, uma funcao gaussiana bi-dimensional
% modulada por uma senooide orientada na direcao Theta e frequencia W. Para
% cada orientacao e escala, um filtro e definido e convoluido sobre a
% imagem de entrada, sendo a energia da imagem convoluida retornada como
% descritor.
% Nessa implementacao, por se tratar de um metodo voltado para texturas
% coloridas, uma transformacao linear do RGB para o modelo de cor Gaussiano
% é aplicada sobre a imagem. Os filtros de Gabor são aplicados e as medidas 
% obtidas para cada um dos canais da imagem.
% 
% IMG: matriz [N x N] contendo uma imagem colorida RGB [0-255], no 
% formato double.
% ESCALAS: numero de escalas utilizadas.
% ORIENTACOES: numero de orientacoes utilizadas.
% [FR_MENOR FR_MAIOR]: frequencias inferior e superior
% 
% DESC: vetor linha contendo os descriptors de energia obtidos para cada canal.
% -------------------------------------------------------------------------
% DESC = TextureColor_GaborFilter_EEE(IMG,ESCALAS,ORIENTACOES)
% Utiliza o valor default para [FR_MENOR FR_MAIOR] = [0.01 0.3]
% 
% Paper
% M. A. Hoang, J. M. Geusebroek, Measurement of color texture, in: Workshop 
% on Texture Analysis in Machine Vision, 2002, pp. 73-76.
% M. A. Hoang, J.-M. Geusebroek, A. W. M. Smeulders, Color texture 
% measurement and segmentation, Signal Processing 85 (2) (2005) 265-275.

if (length(varargin) < 1)
    freq = [0.01 0.3];
else
    freq = varargin{1};
end;

mask = [0.06 0.63 0.31; 0.19 0.18 -0.37; 0.22 -0.44 0.06];

%pre-processamento
img = double(img);
img = img./255;
[nx,ny,nz] = size(img);
for z=1:nx
    for y=1:ny
        img(z,y,:) = mask * squeeze(img(z,y,:));
    end
end

%processamento
gabora = Texture_GaborFilter(img(:,:,1),escalas,orientacao,0,freq);
gaborb = Texture_GaborFilter(img(:,:,2),escalas,orientacao,0,freq);
gaborc = Texture_GaborFilter(img(:,:,3),escalas,orientacao,0,freq);
desc = [gabora gaborb gaborc];