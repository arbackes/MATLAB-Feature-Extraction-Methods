function exemplo_ICA    
    clear all; 
    close all;
    clc;
    % Criação dos três sinais com ruído
    N = 1000; % Número de pontos 
    fs = 500; % Frequência de amostragem
    w = (1:N)*2*pi/fs; % Normalização do vetor da frequência
    t = (1:N); % Vetor do tempo    
    s1 = 0.75*sin(w*12)+0.1*randn(1,N); % Seno duplo
    s2 = sawtooth(w*5,0.5)+0.1*randn(1,N); % Onda triangular
    s3 = pulstran((0:999),(0:5)'*180,kaiser(100,3))+ 0.07*randn(1,N); % Onda periódica    
    %Matriz de mistura
    a = rand(3);
    s =[s1; s2; s3]; % Matriz das fontes originais
    x = a * s; % Sinais misturados/observados
 
%     % Branqueamento da mistura
%     x = branqueamento(x);
%     
%     % Método ICA (usando o algoritmo P-ICA)    
%     y = pca_ica(x);
    % a matriz é transposta pois cada linha deve representar uma amostra
    [y,w] = Calcula_ICA(x');
    y = y';

    % Sinais originais    
    subplot(3,3,1); plot(t,s1); 
    subplot(3,3,4); plot(t,s2); 
    subplot(3,3,7); plot(t,s3); 
    % Sinais misturados    
    subplot(3,3,2); plot(t,x(1,:)); 
    subplot(3,3,5); plot(t,x(2,:)); 
    subplot(3,3,8); plot(t,x(3,:)); 
    % Sinais separados
    subplot(3,3,3); plot(t,y(1,:)); 
    subplot(3,3,6); plot(t,y(2,:)); 
    subplot(3,3,9); plot(t,y(3,:)); 
    
%     % Gráfico dos resultados
%     figure;
%     subplot(3,1,1); plot(t,s1);xlabel('Tempo (s)'); ylabel('s_1(t)');
%     subplot(3,1,2); plot(t,s2);xlabel('Tempo (s)'); ylabel('s_2(t)');
%     subplot(3,1,3); plot(t,s3);xlabel('Tempo (s)'); ylabel('s_3(t)');
%     
% %     figure;
% %     subplot(3,1,1); plot(t,x(1,:));xlabel('Tempo (s)'); ylabel('x_1(t)');
% %     subplot(3,1,2); plot(t,x(2,:));xlabel('Tempo (s)'); ylabel('x_2(t)');
% %     subplot(3,1,3); plot(t,x(3,:));xlabel('Tempo (s)'); ylabel('x_3(t)');
%     
%     figure;
%     subplot(3,1,1); plot(t,y(1,:));xlabel('Tempo (s)'); ylabel('y_1(t)');
%     subplot(3,1,2); plot(t,y(2,:));xlabel('Tempo (s)'); ylabel('y_2(t)');
%     subplot(3,1,3); plot(t,y(3,:));xlabel('Tempo (s)'); ylabel('y_3(t)');

end

%%
% A seguinte função implementa o P-ICA linear
%
% Entrada: x é mistura uma matriz(dxn)
%
% y é os sinais estimados
% w é a matriz de mistura (inversa de A)
%
%
% Autor: Nielsen C. Damasceno
% Data: 20.12.2010
function [y,w] = pca_ica(x)
    n = size(x,1);
    [E, D] = eig(cov(x'));
    v = E*D^(-0.5)*E' * x;
    z = repmat(sqrt(sum(v.^2)),n,1).*v;
    [EE, DD] = eig(cov(z'));
    y = EE'*v;
    w = EE';
end
%%
% A seguinte função implementa o branqueamento
%
% Entrada: x é mistura uma matriz(dxn)
%
% y é uma matriz (dxn)que é o resultado do branqueamento
%
% Autor: Nielsen C. Damasceno
% Data: 20.12.2010
function [y] = branqueamento(x)
    [E, D] = eig(cov(x'));
    y = E*D^(-0.5)*E' * x;
end