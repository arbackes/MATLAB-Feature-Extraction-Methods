function sel = Threshold_ModifiedValleyEmphasis(im)
% SEL = Threshold_ModifiedValleyEmphasis(IM)
% Calcula o threshold de uma imagem em tons de cinza usando o método 
% Modified Valley-Emphasis
% 
% IM: matriz [M x N] contendo uma imagem em tons de cinza [0-255], no
% formato uint8
%
% SEL: threshold calculado
% 
% Paper:
% Jiu-Lun Fan , Bo Lei, A modified valley-emphasis method for automatic
% thresholding, Pattern Recognition Letters, v.33 n.6, p.703-708, 2012   

[h,g] = imhist(im);
h = h / sum(h);

m = 5;% n = 2*m+1 -> 11
for y=1:length(h)
    ini = y-m;
    if(ini < 1)
        ini = 1;
    end;
    fim = y+m;
    if(fim > 256)
        fim = 256;
    end
    
    Hb(y) = sum(h(ini:fim));    
end

muT = sum(g .* h);
sel = 0;
maior = 0;

for t = 1:254
    p0 = sum(h(1:t));
    p1 = sum(h(t+1:end));

    mu0 = sum(g(1:t) .* h(1:t))/p0;
    mu1 = sum(g(t+1:end) .* h(t+1:end))/p1;

    sigma = p0 * mu0^2 +  p1 * mu1^2;
    sigma = (1 - Hb(t)) * sigma;
    
    if(sigma > maior)
        sel = t;
        maior = sigma;
    end
end

