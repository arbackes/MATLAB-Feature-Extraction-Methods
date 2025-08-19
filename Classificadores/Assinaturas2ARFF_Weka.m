function Assinaturas2ARFF_Weka(assin,classes,nome_arff)

[ny,nx] = size(assin);
Nclass = max(classes);
fid = fopen(nome_arff, 'w');

fprintf(fid,'@RELATION dados\n\n');

for y=1:nx
    fprintf(fid,'@ATTRIBUTE A%d	REAL\n',y);
end;

fprintf(fid,'@ATTRIBUTE class {');
for y=1:Nclass-1
    fprintf(fid,'%d, ',y);
end;
fprintf(fid,'%d}\n\n',Nclass);

fprintf(fid,'@DATA\n');
for y=1:ny
    for x=1:nx
        fprintf(fid,'%f, ',assin(y,x));
    end;
    
    fprintf(fid,'%d\n',classes(y));    
end;

%fprintf(fid, formato, variavel)


fclose(fid);