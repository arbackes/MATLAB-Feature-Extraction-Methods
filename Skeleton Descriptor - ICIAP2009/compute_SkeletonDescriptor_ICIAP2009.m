function desc = compute_SkeletonDescriptor_ICIAP2009(im)
% DESC = compute_SkeletonDescriptor_ICIAP2009(IM)
% Calcula descritores de grau calculado a partir do esqueleto de 
% uma imagem binária.
% 
% IM: matriz [M x N] contendo uma imagem binária formato uint8
%
% DESC: descritores calculados
% 
% Paper:
% BACKES, A. R.; BRUNO, O. M. . A Graph-Based Approach for Shape 
% Skeleton Analysis. In: 15th International Conference on Image 
% Analysis and Processing, 2009, Vietri sul Mare. Lecture Notes 
% on Computer Science. Berlim: Springer-Verlag, 2009. v. 5716. 
% p. 731-738.

    limiar = [0.1, 0.21, 0.32, 0.43, 0.54, 0.65];
    
    if (max(im(:)) == 255)
        im = im / 255;
    end;

    im1 = bwmorph(im,'skel',Inf);%esqueletizaçao
    
    [y,x] = find(im1 == 1);
    contorno = [x, y];    
    
    grau = RCAssinForma_MEX(contorno,limiar,0);
    desc = CalculaAssinaturaRC(grau);
    
end

%% ================================================================
function as = CalculaAssinaturaRC(assin)
    [ny,nx] = size(assin);
    % degree
    assin = assin / nx;
    g1 = max(assin');
    g2 = mean(assin');
    as = [g1 g2];
end