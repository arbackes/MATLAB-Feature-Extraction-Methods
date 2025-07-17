function desenha_caminho(contorno,segmentos,ciclo);

c = [contorno; contorno(1,:)];
s = [segmentos segmentos(1)];


plot(c(:,1),c(:,2),'b');title(['Ciclo = ',int2str(ciclo),' Comprimento = ',int2str(length(segmentos))]);
hold on;
plot(c(s,1),c(s,2),'r*-');
hold off;
pause(1);