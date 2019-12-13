function A=generateER(N,k)
% [A,deg] = generateER(N, k)
% Generating a random (Erdos-Renyi), undirected network
% N: numer of nodes
% k: average node degree

mindeg=0;
p=k/(N-1);   %probability of connection;

A=sparse(triu(rand(N)<p)); 
A=A-diag(diag(A));
% make the average degree exaxtly equal to K
difflink=(2*nnz(A)-round(N*k))/2;
if difflink>0
    [i,j]=find(A);
    y = datasample(1:nnz(A),difflink,'Replace',false);
    for index=y
        A(i(index),j(index))=0;
    end
elseif difflink<0
    [i,j]=find(~(A+tril(ones(N))));
    y = datasample(1:nnz(A),-difflink,'Replace',false);
    while(max(y)>numel(i) || max(y)>numel(j))
        A=sparse(triu(rand(N)<p)); 
        A=A-diag(diag(A));
        % make the average degree exaxtly equal to K
        difflink=(2*nnz(A)-round(N*k))/2;
        if difflink>0
            [i,j]=find(A);
            y = datasample(1:nnz(A),difflink,'Replace',false);
            for index=y
                A(i(index),j(index))=0;
            end
        elseif difflink<0
        [i,j]=find(~(A+tril(ones(N))));
        y = datasample(1:nnz(A),-difflink,'Replace',false);
        end
    end
    for index=y
        A(i(index),j(index))=1;
    end
end
A=A+A';



