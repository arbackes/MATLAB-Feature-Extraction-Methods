% A = spaceFillingCurve_GosperFlowsnake(order)
% 
% Calcula a curva de Gosper Flowsnake que preenche todo o espaço 2D
% 
% Entrada:
% order: número de iterações (inteiro)
% 
% Saída:
% A: matriz N x 2 contendo as coordenadas [x y] da curva 
% 
% Exemplo:
% A = spaceFillingCurve_GosperFlowsnake(3);
% plot(A(:,1), A(:,2),'-o'); axis equal

function A = spaceFillingCurve_GosperFlowsnake(order)
    C = flowsnake(order);
    A = [real(C) imag(C)];
    A = bsxfun(@minus, A, min(A));
    A = bsxfun(@rdivide, A, max(A));
end

%%
function z = flowsnake(n)
    %FLOWSNAKE Gosper Flowsnake Curve
    %   Z = FLOWSNAKE(N) is a continuous curve in the complex plane
    %   with 7^N+1 points. N is a nonnegative integer. 
    %
    %   % Example
    %   plot(flowsnake(4)), axis equal

    %   Author: Jonas Lundgren <splinefit@gmail.com> 2010

    % Constants
    a = (1 + sqrt(-3))/2;
    b = (1 - sqrt(-3))/2;
    c = [1; a; -b; -1; -a; b];

    % Segment angles (divided by pi/3)
    u = 0;
    for k = 1:n
        v = u(end:-1:1);
        u = [u; v+1; v+3; u+2; u; u; v-1]; %#ok
    end
    u = mod(u,6);

    % Points
    z = cumsum(c(u+1));
    z = [0; z/7^(n/2)];
end