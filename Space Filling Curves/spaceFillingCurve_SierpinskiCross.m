% A = spaceFillingCurve_SierpinskiCross(order)
% 
% Calcula a curva de Sierpinski Cross que preenche todo o espaço 2D
% 
% Entrada:
% order: número de iterações (inteiro)
% 
% Saída:
% A: matriz N x 2 contendo as coordenadas [x y] da curva 
% 
% Exemplo:
% A = spaceFillingCurve_SierpinskiCross(3);
% plot(A(:,1), A(:,2),'-o'); axis equal

function A = spaceFillingCurve_SierpinskiCross(order)
    C = sierpinski(order);
    A = [real(C) imag(C)];
    A = bsxfun(@minus, A, min(A));
    A = bsxfun(@rdivide, A, max(A));
end

%%
function z = sierpinski(n)
    %SIERPINSKI Sierpinski Cross Curve
    %   Z = SIERPINSKI(N) is a closed curve in the complex plane
    %   with 4^(N+1)+1 points. N is a nonnegative integer. 
    %
    %   % Example
    %   plot(sierpinski(4)), axis equal

    %   Author: Jonas Lundgren <splinefit@gmail.com> 2010

    % Constants
    a = 1 + 1i;
    b = 1 - 1i;
    c = 2 - sqrt(2);

    % Generate point sequence
    z = c;
    for k = 1:n
        w = 1i*z;
        z = [z+b; w+b; a-w; z+a]/2;
    end

    % Close cross
    z = [z; 1i*z; -z; -1i*z; z(1)];
end