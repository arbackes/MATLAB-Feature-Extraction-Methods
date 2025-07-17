function [aprox,erro] = Executa_split_merge(contorno,arcos,caminho,ErroGlobal);

ponto = round(rand * (length(caminho)-1) + 1);
aprox = split_merge(contorno,arcos,caminho, ponto);
erro = calcula_erro_arco_segmento(aprox,arcos);
if erro > ErroGlobal
    aprox = caminho;
end;

%================================================================
function erro = calcula_erro_arco_segmento(segmento,arcos_dist);
tam = length(segmento);

d = 0;
for k =1:tam-1    
    d = d + arcos_dist(segmento(k),segmento(k+1));    
end;

erro = d + arcos_dist(segmento(tam),segmento(1));