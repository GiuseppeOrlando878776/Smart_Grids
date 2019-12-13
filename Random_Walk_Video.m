clc;
close all;
clear all;
%% Generazione della rete
fprintf('Stiamo simulando una rete Watts-Strogatz \n');
N = input('\nInserisci il numero di nodi desiderati: ');
m = input('Inserisci il numero di nodi da collegare a destra e a sinistra: ');
p = input('Inserisci la probabilità di rewiring: ');
dw = input('Inserisci il reinforcement: ');
ws = WattsStrogatz(N,m,p);
ws.Edges.Weights = ones(numedges(ws),1);
edges = ws.Edges{:,:}(:,1:2); % Seleziono la matrice di adiacenza
%% Visualizzazione della rete
figure()
P = plot(ws);
title(['Topologia rete Watts-Strogatz (N = ',num2str(N),', m = ',num2str(m),', \beta = ',num2str(p),')'])
%% Simulazione random walk
colore = P.NodeColor;
niter = 300;
iter = 0;
x = datasample(1:N,1);
highlight(P,x,'NodeColor','g');
hold on
plot(NaN,NaN,'og','MarkerFaceColor','g');
legend('Actual Node','Location','Best')
legend boxoff
title({['Topologia rete Watts-Strogatz (N = ',num2str(N),', m = ',num2str(m),', \beta = ',num2str(p),')'];['t = ',num2str(iter)]});

%% ++ SCELTA SALVATAGGIO VIDEO ++ %%
flag=input('Do you want to save the velocity animation?: ','s');
if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    duration = 20;
    uncompressed=input('Press U for uncompressed AVI(best quality but really huge), type another key otherwise: ','s');
    if(uncompressed=='u' | uncompressed=='U') 
        v = VideoWriter('Animation','Uncompressed AVI');   
    else
        v = VideoWriter('Animation','MPEG-4');
    end
    v.Quality = 100;
%    v.FrameRate = ceil(niter/duration);
%    open(v);
end
fprintf('\nPremi un tasto per iniziare la simulazione \n');
pause();

%% ++ INIZIO CICLO SIMULAZIONE RANDOM WALK ++ %%
while(iter < niter)
    iter = iter+1;
    xold = x;
    near_edges = find(edges==xold); % Trovo i link in cui è presente il nodo attuale
    [edges_row,j] = ind2sub(size(edges),near_edges); % Trovo la riga corrispondente nella matrice di adiacenza
    near_weights = ws.Edges.Weights(edges_row); % Seleziono i pesi dei link trovati
    num_selected_edge = datasample(edges_row,1,'Weights',near_weights); % Seleziono il numero dell'edge con i pesi
    selected_edge = edges(num_selected_edge,:); % Seleziono il link effettivamente scelto
    new_index = find(selected_edge~=xold); % Trovo l'indice del punto di arrivo nel link selezionato (o 1 o 2)
    x = selected_edge(new_index); % Questo è il nuovo nodo
    ws.Edges.Weights(edges(num_selected_edge)) = ws.Edges.Weights(edges(num_selected_edge)) + dw; % Aggiorno il peso
    highlight(P,xold,'NodeColor',colore);
    highlight(P,x,'NodeColor','g');
    title({['Topologia rete Watts-Strogatz (N = ',num2str(N),', m = ',num2str(m),', \beta = ',num2str(p),')'];['t = ',num2str(iter)]});
    drawnow
    pause(0.01)
    if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
        frame(iter) = getframe(gcf);
    %    writeVideo(v,frame(iter));
    end
end

%% ++ MODIFICA A POSTERIORI DURATA SE NON SI CONOSCE A PRIORI NUMERO ITERAZIONI ++ %%
if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    % duration = 20;
    v.FrameRate = ceil(numel(frame)/duration);
    open(v);
    for i = 1:numel(frame)
        writeVideo(v,frame(i));
    end
end

%% ++ CHIUSURA VIDEO ++ %%
if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    close(v);
end

%% ++ SALVATAGGIo PRIMO FRAME PER SLIDE LATEX++ %%
v = VideoReader('Animation.mp4');
frame = readFrame(v);
imwrite(frame,'First_frame.png');