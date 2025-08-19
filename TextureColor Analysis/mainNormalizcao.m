clear;clc;close all;
caminhoGravar1 = 'D:\Artigo Gondim\myMethod\stain normalization\';
complementoGravar = '.png';
i=0;
l = 0;
idx = 0;
Files=dir('D:\Artigo Gondim\WBC_SegProposed\BloodImageSetS6NucSeg\Nucleus\*.jpg');%read all .jpg files in folder Nucleus
for n=1:length(Files)
    [rgb,map, alpha] = imread(strcat('D:\Artigo Gondim\WBC_SegProposed\BloodImageSetS6NucSeg\',Files(n).name));
    rgb = im2double(rgb);
        [q, w, e]= size(rgb);
        final = zeros(q,w,e);
        minimo = 255;
        maximo = 0;
        xLow = 255;
        xHigh = 0;
        
        for k = 1:3
            %seleciona o canal
            grayIMG = rgb(:,:,k);
            %x contem a quantidade de pixels por intensidade, edges são as intensidades
            [x,edges] = histcounts(grayIMG);
            %faço o total de pixel retirando os brancos para interferir menos na normalizacao
            total = sum(x(:,1:end-1));
            % crio um vetor no qual as posicoes que satisfazem são 1 e o restantente 0
            Manter = (x(:,1:end-1) > total*0.002 & x(:,1:end-1)< total*0.1);
            % Seleciono o indice de cada posicao de Manter
            xManter = find(Manter);
            % Encontro a intensidade com menos pixels
            [low, indiceLow] = min(edges(xManter));
            %Encontro a intensidade com mais pixels
            [high, indiceHigh] = max(edges(xManter));
            %Pego o valor da intensidade com menos pixels
            xLowAux = edges(xManter(indiceLow));
            %Pego o valor da intensidade com mais pixels
            xHighAux = edges(xManter(indiceHigh));
            %Seleciono o menor dos 3 canais
            if xLowAux < xLow
                xLow = xLowAux;
            end
            %Seleciono o maior dos 3 canais
            if xHighAux > xHigh
                xHigh= xHighAux;
            end
            %Seleciono intensidade minima de cada canal
            if min(min(grayIMG)) < minimo
                minimo = (min(min(grayIMG)));
            end
            %Seleciono intensidade maxima de cada canal retirando o branco
            grayIMGAux = grayIMG;
            grayIMGAux(grayIMGAux == 255) = 0;
            [max1, ind1] = max(max(grayIMGAux));
            
            
            if max1 > maximo
                maximo = max1;
            end
            
        end
        for k=1:3
            nova =rgb(:,:,k);
            nova (nova < xLow) = minimo;
            nova (nova > xHigh) = maximo;
            %nova (nova > xLow & nova < xHigh) = (nova-xLow)*(255/(xHigh - xLow));
            for i = 1:q
                for j = 1:w
                    if (nova(i,j) > xLow && nova(i,j) <= xHigh)
                        nova(i,j) =minimo+((nova(i,j)-xLow)*maximo/(xHigh - xLow));
                    end
                end
            end
            final(:,:,k) = nova;
        end
        %figure, imshow(final);
        
        imwrite(final, strcat(caminhoGravar1, num2str(idx), complementoGravar));
        
    
    

    idx = idx+1;
    
end