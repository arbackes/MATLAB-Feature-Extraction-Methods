function res = Classifica_LDA_HoldOut(dados,classes)    
    if(size(classes,1) < size(classes,2))
        classes = classes';
    end
    
    N = 10;
    res = 0;
    for y=1:N
        [TreinoD,TreinoC,TesteD,TesteC] = separa_dados(dados,classes);
        f = lda(TreinoD,TreinoC);
        [c,post] = classify(f,TesteD);        
        acertos = sum(c == TesteC);
        res = res + (100*acertos/length(TesteC));
    end
    res = res/N;    
end

function [TreinoD,TreinoC,TesteD,TesteC] = separa_dados(dados,classes)
    N = max(classes);
    TreinoD = [];
    TreinoC = [];
    TesteD = [];
    TesteC = [];
    
    for y=1:N
        c = find(classes == y);
        [Tr, Te] = crossvalind('HoldOut', length(c), 0.34);
        TreinoD = [TreinoD; dados(c(Tr),:)];
        TreinoC = [TreinoC; classes(c(Tr),:)];
            
        TesteD = [TesteD; dados(c(Te),:)];
        TesteC = [TesteC; classes(c(Te),:)];
    end
end