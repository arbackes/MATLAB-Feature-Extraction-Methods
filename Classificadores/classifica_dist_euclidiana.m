function [acertos,res] = classifica_dist_euclidiana(assin,classe)

dist = squareform(pdist(assin,'seuclidean'));
[v,ind] = sort(dist,2);
acertos = sum(classe(ind(:,2)) == classe);
res = 100*acertos/length(classe);

%%
% N = length(classe);
% dist = zeros(N,N);
% 
% for y=1:N-1
%     for x=(y+1):N
%         d = sqrt(sum((assin(y,:)-assin(x,:)).^2));
%         dist(y,x) = d;
%         dist(x,y) = d;
%     end;
% end;
% 
% maior = max(dist(:));
% for y=1:N
%     dist(y,y) = maior;
% end;
% 
% acertos = 0;
% for y=1:N
%     [v,ind] = sort(dist(y,:));
%     if (classe(y) == classe(ind(1)))
%         acertos = acertos + 1;
%     end;
% end;
% 
% res = 100*acertos/length(classe);
