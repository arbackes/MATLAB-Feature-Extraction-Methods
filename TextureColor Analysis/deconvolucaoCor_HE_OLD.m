% [hematoxilina, eosina, dab] = deconvolucaoCor_HE(rgb)
% Calcula a deconvolução de cor de imagens RGB tingidas com Hematoxilina e
% Eosina (H & E)
% 
% Paper: RUIFROK, A. C.; JOHNSTON, D. A. Quantification of histochemical 
% staining by color deconvolution. Analytical and quantitative cytology 
% and histology, v. 23, n. 4, p. 291–299, 2001.

function [hematoxilina, eosina, dab] = deconvolucaoCor_HE_OLD(rgb)

    [height, width, channel] = size(rgb);

    H_deinterlace = [0 1 0; 0 2 0; 0 1 0] ./4;

    sample_deinterlace = zeros(height, width, channel);
    for k=1:channel
        sample_deinterlace(:,:,k) = filter2(H_deinterlace,double(rgb(:,:,k)),'same');
    end

    % densidade optica da imagem
    sampleRGB_OD = -log((sample_deinterlace+1)./256); 

    % Create Deconvolution matrix
    M = [0.65 0.70 0.29; ...
         0.07 0.99 0.11; ...
         0.27 0.57 0.78];
    D = inv(M);
    
    % Aplica deconvolucao
    P = reshape(sampleRGB_OD,height * width, 3) * D';
    sampleHEB_OD = reshape(P,height, width, 3);

    hematoxilina = sampleHEB_OD(:,:,1);
    eosina = sampleHEB_OD(:,:,2);
    dab = sampleHEB_OD(:,:,3);
    
    % normaliza 0-255
    me = min(hematoxilina(:));
    if(me < 0)
        hematoxilina = hematoxilina - me;
    end
    hematoxilina = uint8(255*hematoxilina/max(hematoxilina(:)));
    
    me = min(eosina(:));
    if(me < 0)
        eosina = eosina - me;
    end
    eosina = uint8(255*eosina/max(eosina(:)));
    
    me = min(dab(:));
    if(me < 0)
        dab = dab - me;
    end
    dab = uint8(255*dab/max(dab(:)));
end