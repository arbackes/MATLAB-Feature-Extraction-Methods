function desenha(curva,cam)

plot(curva(:,1),-curva(:,2),'.'); hold on;
plot(curva(cam,1),-curva(cam,2),'-o'); hold off
title(int2str(length(cam)));
pause(1);