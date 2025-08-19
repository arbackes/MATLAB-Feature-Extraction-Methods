function B = Distance_Bhattacharyya(data,classes)
% Distancia Battacharyya
% B = Distance_Bhattacharyya(data,classes)
% Calcula a distancia Battacharyya entre conjuntos de dados de diferentes
% classes. A distancia Battacharyya mede a separabilidade entre classes
% durante a classificação
% 
% data: matriz [N x M] contendo os vetores de caracteristicas de cada
% elemento.
% classes: array de [N x 1] ou [1 x N] contendo a classe da cada elemento
% 
% B: matriz [K x K] contendo a distancia Battacharyya entre cada classe,
% onde K é o numero de classes em data

m = max(classes);

B = zeros(m,m);

for y=1:m-1
    asY = data(find(classes == y),:);
    CY = cov(asY);
    MY = mean(asY,1);
    for x=(y+1):m
        asX = data(find(classes == x),:);
        CX = cov(asX);
        MX = mean(asX,1);
        
        B(y,x) = 1/8*(MY-MX) * inv((CY+CX)/2)*(MY-MX)'+(1/2)*log(det((CY+CX)/2)/sqrt(det(CX)*det(CY)));
        B(x,y) = B(y,x);
    end;
end;