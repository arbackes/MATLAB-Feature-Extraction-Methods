function aprox = split_merge(contorno,arcos,caminho,ponto);

cam = caminho;
cam(ponto) = [];
dy = length(contorno);
nro_pontos = length(cam);

cont = 0;
ini = mod(ponto,nro_pontos) + 1;
atual = ini;

while cont < 1       
    next = mod(atual,nro_pontos) + 1;% primeiro vizinho = indice caminho
    p2 = mod(next,nro_pontos) + 1;% segundo vizinho = indice caminho
    
    %disp(['cam = ',int2str(length(cam)),'  atual = ',int2str(atual)]);
    p = mod(cam(atual),dy) + 1;    
    p_esc = p;
    erro = arcos(cam(atual),p) + arcos(p,cam(p2));
    
    while p ~= cam(p2)
        erro1 = arcos(cam(atual),p) + arcos(p,cam(p2));
        if erro1 <= erro
            erro = erro1;
            p_esc = p;
        end;
        p = mod(p,dy) + 1;        
    end;
    
    cam(next) = p_esc;
    atual = mod(atual,nro_pontos) + 1;
    
    if atual == ini
        cont = cont + 1;
    end;
end;

aprox = cam;
