% A = spaceFillingCurve_Hilbert(order)
% 
% Calcula a curva de Hilbert que preenche todo o espaço 2D
% 
% Entrada:
% order: número de iterações (inteiro)
% 
% Saída:
% A: matriz N x 2 contendo as coordenadas [x y] da curva 
% 
% Exemplo:
% A = spaceFillingCurve_Hilbert(3);
% plot(A(:,1), A(:,2),'-o'); axis equal

function A = spaceFillingCurve_Hilbert(order)
    A = zeros(0,2);
    B = zeros(0,2);
    C = zeros(0,2);
    D = zeros(0,2);

    north = [ 0  1];
    east  = [ 1  0];
    south = [ 0 -1];
    west  = [-1  0];

    %order = 3;
    for n = 1:order
        AA = [B ; north ; A ; east  ; A ; south ; C];
        BB = [A ; east  ; B ; north ; B ; west  ; D];
        CC = [D ; west  ; C ; south ; C ; east  ; A];
        DD = [C ; south ; D ; west  ; D ; north ; B];

        A = AA;
        B = BB;
        C = CC;
        D = DD;
    end

    A = [0 0; cumsum(A)];
    A = bsxfun(@rdivide, A, max(A));
end