function erro = calculaErro(segmento,arcos_dist);
tam = length(segmento);

d = 0;
for k =1:tam-1    
    d = d + arcos_dist(segmento(k),segmento(k+1));    
end;

erro = d + arcos_dist(segmento(tam),segmento(1));