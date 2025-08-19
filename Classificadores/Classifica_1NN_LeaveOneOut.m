function res = Classifica_1NN_LeaveOneOut(assin,classe)
    dist = squareform(pdist(assin,'seuclidean'));
    [v,ind] = sort(dist,2);
    acertos = sum(classe(ind(:,2)) == classe);
    res = 100*acertos/length(classe);
end