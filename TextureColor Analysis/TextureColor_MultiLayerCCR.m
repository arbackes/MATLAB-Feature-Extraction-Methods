% DESC = TextureColor_MultiLayerCCR(IMAGE,MAPPING,MAPACOLORT)
% Calcula o conjunto de histogramas de uma imagem utilizando Coordinated 
% Clusters Representation (CCR) para cada um dos N padroes de cores obtidos
% utilizando uma tabela de cores previamente definida.
% 
% IMAGE: matriz [N x N] contendo uma imagem RGB [0-255], no formato uint8.
% 
% MAPPING: estrutura contendo a tabela de mapeamento para o CCR baseado no 
% LBP. É obtida utilizando a funcao Texture_LBP_Mapping.
% Ex: mapping = Texture_LBP_Mapping(tipo);
% 
% MAPACOLORT: matriz [256 x 256 x 256] contendo o indice de cada cor do
% espaço RGB de acordo com uma tabela de cores previamente estipulada.
% 
% DESC: conjunto de histogramas normalizados do CCR obtido a 
% partir da imagem IMAGE usando o mapeamento MAPPING e o mapeamento de 
% cores MAPACOLORT. 
% 
% Ex:
% image = imread('hestain.png');
% [colorT,mapaColorT] = colorTable(4);
% mapping = Texture_LBP_Mapping(1);
% desc = TextureColor_MultiLayerCCR(image,mapping,mapaColorT);
% 
% Paper:
% F. Bianconi, A. Fernandez, E. Gonzalez, D. Caride, A. Calvino 
% Rotation-invariant colour texture classification through multilayer CCR,
% Pattern Recognition Letters 30(8)(2009), 765-773
% 
% Adaptado de: http://www.ee.oulu.fi/mvg/page/lbp_matlab

function desc = TextureColor_MultiLayerCCR(image,mapping,mapaColorT)

neighbors = mapping.samples;
switch mapping.samples
    case 8
        radius = 1;
    case 16
        radius = 2;
    case 24
        radius = 3;
end;

numColor = max(mapaColorT(:));%nro de cores da tabela
d_image = double(image);

spoints=zeros(neighbors,2);

% Angle step.
a = 2*pi/neighbors;

for i = 1:neighbors
    spoints(i,1) = -radius*sin((i-1)*a);
    spoints(i,2) = radius*cos((i-1)*a);
end

% Determine the dimensions of the input image.
[ysize,xsize,zsize] = size(image);

miny = min(spoints(:,1));
maxy = max(spoints(:,1));
minx = min(spoints(:,2));
maxx = max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
C = image(origy:origy+dy,origx:origx+dx,:);
d_C = double(C);

% CONVERTE PARA A TABELA DE CORES
imC = converteRGB2Colormap(C,mapaColorT);
imd_C = converteRGB2Colormap(d_C,mapaColorT);

bins = 2^neighbors;

% Initialize the result matrix with zeros.
result = zeros(dy+1,dx+1,numColor);

%Compute the LBP code image

for i = 1:neighbors
  v = 2^(i-1);
  
  y = spoints(i,1)+origy;
  x = spoints(i,2)+origx;
  % Calculate floors, ceils and rounds for the x and y.
  fy = floor(y); cy = ceil(y); ry = round(y);
  fx = floor(x); cx = ceil(x); rx = round(x);
  % Check if interpolation is needed.
  if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
    % Interpolation is not needed, use original datatypes
    N = image(ry:ry+dy,rx:rx+dx,:);
    
    %TRATAR AS CORES
    imN = converteRGB2Colormap(N,mapaColorT);
    for k=1:numColor
        D = (imN == k) & (imC == k);
        result(:,:,k) = result(:,:,k) + v*D;
    end;    
%     D = N >= C; 
  else
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
    w1 = (1 - tx) * (1 - ty);
    w2 =      tx  * (1 - ty);
    w3 = (1 - tx) *      ty ;
    w4 =      tx  *      ty ;
    
    %TRATAR AS CORES
    % Compute interpolated pixel values
    N = w1*d_image(fy:fy+dy,fx:fx+dx,:) + w2*d_image(fy:fy+dy,cx:cx+dx,:) + ...
        w3*d_image(cy:cy+dy,fx:fx+dx,:) + w4*d_image(cy:cy+dy,cx:cx+dx,:);
    
    %TRATAR AS CORES
    imN = converteRGB2Colormap(round(N),mapaColorT);
    for k=1:numColor        
        D = (imN == k) & (imd_C == k);
        result(:,:,k) = result(:,:,k) + v*D;
    end;
%     D = N >= d_C; 
  end  
  % Update the result matrix.
%   v = 2^(i-1);
%   result = result + v*D;
end

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    for i = 1:size(result,1)
        for j = 1:size(result,2)
            for k=1:numColor%TRATAR AS CORES
                result(i,j,k) = mapping.table(result(i,j,k)+1);
            end;
        end
    end
end

desc = zeros(bins,numColor);
for k=1:numColor%TRATAR AS CORES
    re = result(:,:,k);
    re = hist(re(:),0:(bins-1));
    re = re /sum(re);
    desc(:,k) = re(:);
end;

desc = desc(:)';