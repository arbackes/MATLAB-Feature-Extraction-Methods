function desc = compute_SkeletonDescriptor_ICISP2010(im)
% desc = compute_SkeletonDescriptor_ICISP2010(im)
% 
% Calcula descritores de grau calculado a partir do esqueleto de 
% uma imagem binária usando redes complexas e dimensão fractal 
% multiescala.
% 
% IM: matriz [M x N] contendo uma imagem binária formato uint8
%
% DESC: descritores calculados
% 
% Paper:
% BACKES, A. R.; BRUNO, O. M. . Shape Skeleton Classification Using 
% Graph and Multi-scale Fractal Dimension. In: 4th International 
% Conference On Image And Signal Processing (ICISP 2010), 2010, 
% Trois-Rivières, QC, Canada. Lecture Notes in Computer Science, 
% 2010. v. 6134. p. 448-455.


    limiar = 0.005:0.005:0.95;
    ind = 1:190;
    li = log(limiar);
    
	if (max(im(:)) == 255)
        im = im / 255;
    end;

    im1 = bwmorph(im,'thin',Inf);%afinamento
    
    [y,x] = find(im1 == 1);
    contorno = [x, y];
    grau = RCAssinForma_MEX(contorno,limiar,0);
    N = size(grau,2);
    sigma = 1.50;
    
    g = min(grau');
    for x=1:length(g)
        if g(x) > 0
            g(x) = log(g(x)/N);
        else
            g(x) = 0;
        end;
    end;   
    dfm = DFM_MassaRaio([li(ind)' g(ind)'],sigma);
    as1 = dfm(:,2)';
    
    g = max(grau');
    for x=1:length(g)
        if g(x) > 0
            g(x) = log(g(x)/N);
        else
            g(x) = 0;
        end;
    end;   
    dfm = DFM_MassaRaio([li(ind)' g(ind)'],sigma);
    as2 = dfm(:,2)';
    
    g = mean(grau');
    for x=1:length(g)
        if g(x) > 0
            g(x) = log(g(x)/N);
        else
            g(x) = 0;
        end;
    end;   
    dfm = DFM_MassaRaio([li(ind)' g(ind)'],sigma);
    as3 = dfm(:,2)';
    
    n = 7;
    sel = 13:length(as1);    
    [P,S] = polyfit(dfm(sel,1),as1(sel)',n); %MIN
    desc = P(1:n+1);
%     
    [P,S] = polyfit(dfm(sel,1),as2(sel)',n); % MAX
    desc = [desc P(1:n+1)];
%     
    [P,S] = polyfit(dfm(sel,1),as3(sel)',n); % MEAN
    desc = [desc P(1:n+1)];
    
    
end
%% =======================================================
    function mr = DFM_MassaRaio(m, sigma)
    % function mr = DFM_MassaRaio(nome_arquivo, sigma)
    % m = dlmread(nome_arquivo,' ');

    % c= find(m(:,1)>1.85);
    % mc = m(c,:);
    mc = m;
    [ny,nx]= size(mc);

    primeiro= mc(1,1);
    mc = interpolacao(mc);
    mc = interpolacao(mc);
    mc = interpolacao(mc);
    mc = amostragem(mc);

    [ny1,nx1] = size(mc);

    mc = replicar_curva(mc);
    %APLICAR DERIVADA...
    cte =abs(mc(2,1)-mc(1,1));
    m2 = mc;
    m2(:,2) = Derivada_Fourier(mc(:,2),sigma,cte);

    mr = m2(2*ny1+1:3*ny1,:);
    diferenca = mr(1,1)-primeiro;
    mr(:,1) = mr(:,1) - diferenca;

    % interpolar_derivada=1;
    % if interpolar_derivada 
    %     rx= 1.9:0.5:3.5;
    %     ry = polint(mr(:,1),mr(:,2),rx);  
    %     mr = [rx' ry'];
    % end;
end
%=======================================================
function m = amostragem(curva)
    deltax = curva(2,1) - curva(1,1);
    [ny,nx] = size(curva);
    m(1,:)= curva(1,:);
    m(2,:)= curva(2,:);
    last = 2;%ultmo ponto adicionado...
    indice=3;
    for x=3:ny
        if abs(curva(x,1) - curva(last,1)) > deltax              
            if abs(curva(x,1) - curva(last,1) -deltax) < abs(curva(x-1,1) - curva(last,1) -deltax)%PROCURA MENOR DIFERENÇA...       
                last = x;
            else
                last = x-1;
            end;
            m(indice,:) = curva(last,:);
            indice=indice +1;        
        end;    
    end;
end
%% =======================================================
function [mr] = interpolacao(m);
    ny = 2 * length(m) - 1;
    med = (m(1:end-1,:) + m(2:end,:))/2;
    mr(2:2:ny,:) = med(:,:);
    mr(1:2:ny,:) = m(:,:);
end
%% =======================================================
function mr = replicar_curva(m)
    [ny,nx] = size(m);
    %calcula m1...
    m1 = m;

    %calcula m2...
    m2 = zeros(ny,2);
    m2(:,2) = -m1(end:-1:1,2) + 2*max(m1(:,2));
    m2(:,1) = -m1(end:-1:1,1) + 2*max(m1(:,1));

    %calcula m3...
    m3 = zeros(ny,2);
    m3(:,2) = m1(:,2) + max(m2(:,2)) - min(m1(:,2));
    m3(:,1) = m1(:,1) + 2*max(m1(:,1)) - 2*min(m1(:,1));

    %calcula m4...  
    m4 = zeros(ny,2);
    m4(:,2) = -m1(end:-1:1,2) + max(m1(:,2)) + max(m3(:,2));
    m4(:,1) = -m1(end:-1:1,1) + max(m1(:,1)) + max(m3(:,1));

    ma = Concatena_Curvas(m1,m2);
    ma = Concatena_Curvas(ma,m3);
    mr = Concatena_Curvas(ma,m4);
end
%% =======================================================
function d = Derivada_Fourier(V,sigma,cte)
    %VALOR QUE ERA USADO PARA SIGMA...
    %sigma=1.54;

    [nx,N] = size(V);
    if nx > N 
        N=nx;
    end;

    % Faz a transformada.
    F = fft(V);

    % Deslocamento para o centro
    F = fftshift(F);

    %Cria f
    min =  - ceil((N - 1) / 2);
    max = floor((N - 1)/ 2);
    f = (min:max) / N;

    % Cria a gaussiana no domínio das freqüências.
    FG = gaussiana_frequencia(N,sigma);

    % Cria um operador que realiza a derivada no domínio das freqüências.
    D = 2 * pi * i * f/cte;

    GED = F(:) .* FG(:) .* D(:);

    GED = ifftshift(GED);

    % Calculo da transformada inversa para voltar ao dominio do tempo
    d = real(ifft(GED));
end
%% =======================================================
function g = gaussiana_frequencia(N,sigma);
    %Cria f
    min =  - ceil((N - 1) / 2);
    max = floor((N - 1)/ 2);
    f = (min:max) / N;

    % Cria a gaussiana no domínio das freqüências.
    g = exp(- 2 * (pi * sigma * f).^2);
end
%% =======================================================
function mr = Concatena_Curvas(m1,m2);
    mr = [m1(1:end-1,:); m2];
end