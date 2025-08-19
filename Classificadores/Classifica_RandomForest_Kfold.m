function res = Classifica_RandomForest_Kfold(dados,classes,K)    
    if(size(classes,1) < size(classes,2))
        classes = classes';
    end
    
    Folds = separa_dados(classes,K);    
    res = 0;
    for y=1:K   
        try
            
            B = TreeBagger(30,dados(Folds(y).treino,:),classes(Folds(y).treino),'Method','classification');
            c = B.predict(dados(Folds(y).teste,:));
            c = str2double(c);
            acertos = sum(c == classes(Folds(y).teste));
            res = res + acertos;
        catch
        end
    end
    res = 100 * res/length(classes);    
end

function Folds = separa_dados(classes,K)
    N = max(classes);
    Folds(K) = struct('treino',[],'teste',[]);
    
    for y=1:N
        C = find(classes == y);
        Indices = crossvalind('Kfold', length(C), K);
        
        for x=1:K
            Folds(x).teste = [Folds(x).teste; C(Indices == x)];
            Folds(x).treino = [Folds(x).treino; C(Indices ~= x)];
        end
    end
end