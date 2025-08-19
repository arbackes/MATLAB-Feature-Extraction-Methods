% ccm = TextureColor_CCM(RGB,d)
% Calcula o conjunto de histogramas de uma imagem colorida utilizando 
% Chromatic co-occurrence matrices (CCM).
% 
% RGB: matriz [N x M] contendo uma imagem RGB [0-255], no formato uint8.
% D: valor inteiro de distância usado no cálculo da matriz de co-ocorrência
% 
% CCM: struct contendo 6 campos. Cada campo representa a matriz de 
% co-ocorrência de cores entre canais usando o método de 
% Chromatic co-occurrence matrices (CCM).
% 
% Ex:
% image = imread('hestain.png');
% ccm = TextureColor_CCM(image,2);
% 
% Paper:
% C.Palm,Color texture classification by integrative co-occurrence
% matrices, Pattern Recognition 37(5)(2004) 965–976.
% 
% C.-Y Wang, A Rosenfeld, Multispectral texture; IEEE Trans. Systems, Man, 
% Cybernetics, 12 (1982), pp. 79–84

function ccm = TextureColor_CCM(RGB,d)
    viz = vizinhos(d);
    ccm.RR = computeCCM(RGB,1,1,viz);
    ccm.RG = computeCCM(RGB,1,2,viz);
    ccm.RB = computeCCM(RGB,1,3,viz);
    ccm.GG = computeCCM(RGB,2,2,viz);
    ccm.GB = computeCCM(RGB,2,3,viz);
    ccm.BB = computeCCM(RGB,3,3,viz);    
end

function viz = vizinhos(d)
    viz = [];
    for y=-d:d:d
        for x=-d:d:d
            if(x == 0 && y == 0)
                continue;
            end
            viz = [viz; y x];
        end
    end
end

function ma = computeCCM(RGB,c1,c2,viz)
    ma = zeros(256,256);
    [ny,nx,~] = size(RGB);
    N = size(viz,1);
    for y=1:ny
        for x=1:nx
            for k=1:N
                py = y + viz(k,1);
                px = x + viz(k,2);
                if(py > 0 && px > 0 && py <= ny && px <= nx)
                    cor1 = RGB(y,x,c1) + 1;
                    cor2 = RGB(py,px,c2) + 1;
                    ma(cor1,cor2) = ma(cor1,cor2) + 1;
                end
            end
        end
    end    
    
    ma = ma/sum(ma(:));
end