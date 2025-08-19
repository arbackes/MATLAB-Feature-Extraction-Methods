function [md,mt] = TextureColor_ChromaticityMoments(im)
% Este metodo se baseia no conceito de cromaticidade definido no espaço de 
% cor CIE XYZ, onde cada pixel resulta em uma coordenada (x,y) de valores
% de cromaticidade. A partir dessa distribuicao de cromaticidade, momentos
% são calculados para compor uma assinatura que permita caracterizar uma
% imagem em ternos de cor e textura.
% 
% [MD,MT] = TextureColor_ChromaticityMoments(IM)
% IM: matriz [N x N] contendo uma imagem colorida RGB [0-255], no 
% formato double.
% 
% MD: vetor linha contendo 36 momentos calculados da distribuicao de
% cromaticidades D.
% MT: vetor linha contendo 36 momentos calculados da distribuicao de
% cromaticidades T, onde 
%   T(i,j) = 1 se D(i,j) > 0;
%   T(i,j) = 0 se D(i,j) = 0;
% 
% Paper:
% G. Paschos, Fast color texture recognition using chromaticity moments, 
% Pattern Recognition Letters 21 (9) (2000) 837-841.

[ny,nx,nz] = size(im);

X = 1 + 0.607 * im(:,:,1) + 0.174 * im(:,:,2) + 0.200 * im(:,:,3);
Y = 1 + 0.299 * im(:,:,1) + 0.587 * im(:,:,2) + 0.114 * im(:,:,3);
Z = 1 + 0.066 * im(:,:,2) + 1.111 * im(:,:,3);

x = X ./ (X + Y + Z);
y = Y ./ (X + Y + Z);

n = 100;
x = round(x * (n-1) + 1);
y = round(y * (n-1) + 1);
T = zeros(n,n);
D = zeros(n,n);

for py=1:n
    for px=1:n
        T(y(py,px),x(py,px)) = 1;
        D(y(py,px),x(py,px)) = D(y(py,px),x(py,px)) + 1;
    end;
end;

md = [];
mt = [];
[x,y] = meshgrid(1:100,1:100);
for M=0:5
    for L=0:5
        xM = x.^M;
        yL = y.^L;
        md = [md, sum(sum((xM .* yL .* D)))];
        mt = [mt, sum(sum((xM .* yL .* T)))];
    end;
end;