function sel = Threshold_ValleyEmphasis(im)
% SEL = Threshold_ValleyEmphasis(IM)
% Calcula o threshold de uma imagem em tons de cinza usando o método 
% Valley-Emphasis
% 
% IM: matriz [M x N] contendo uma imagem em tons de cinza [0-255], no
% formato uint8
%
% SEL: threshold calculado
% 
% Paper:
% Ng, H.F., 2006. Automatic thresholding for defect detection. Pattern 
% Recognition Lett. 27, 1644–1649.

[h,g] = imhist(im);
h = h / sum(h);
muT = sum(g .* h);
sel = 0;
maior = 0;

for t = 1:254
    p0 = sum(h(1:t));
    p1 = sum(h(t+1:end));

    mu0 = sum(g(1:t) .* h(1:t))/p0;
    mu1 = sum(g(t+1:end) .* h(t+1:end))/p1;

    sigma = p0 * mu0^2 +  p1 * mu1^2;
    sigma = (1 - h(t)) * sigma;
    
    if(sigma > maior)
        sel = t;
        maior = sigma;
    end
end

