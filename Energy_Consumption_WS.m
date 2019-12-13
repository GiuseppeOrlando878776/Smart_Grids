clc;
close all;
clear all;
%% Generazione della rete
fprintf('Stiamo simulando una rete Watts-Strogatz \n');
N = input('\nInserisci il numero di nodi desiderati: ');
% NumNodi = 100;
% fprintf(['\nIl logaritmo in base 2 del numero di nodi e'' ',num2str(log2(N)),'\n']);
m = input('Inserisci il numero di nodi da collegare a destra e a sinistra: ');
p = input('Inserisci la probabilità di rewiring: ');
ws = WattsStrogatz(N,m,p);
% while(max(max(distances(er))==Inf)) % Genero una rete connessa
%     ER = generateER(N,k);
%     er = graph(ER);
% end
% MeanDegree = mean(degree(er));
% fprintf(['Il grado medio ottenuto e'' ',num2str(MeanDegree),'\n']);

%% Setting parametri
alfa = input('Inserisci la percentuale di utenti on desiderata: ');
%% Visualizzazione della rete
figure()
P = plot(ws);
title({['Topologia rete Watts-Strogatz (N = ',num2str(N),', m = ',num2str(p),')'];['\alpha = ',num2str(alfa)]});
%% Scelta salvataggio
str = num2str(alfa);
flag=input('Do you want to save the velocity animation?: ','s');
if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    uncompressed=input('Press U for uncompressed AVI(best quality but really huge), type another key otherwise: ','s');
    if(uncompressed=='u' | uncompressed=='U') 
        v = VideoWriter(['Original_WS(0,',str(3:end),')'],'Uncompressed AVI');   
    else
        v = VideoWriter(['Original_WS(0,',str(3:end),')'],'MPEG-4');
    end
    v.Quality = 100;
end
%% Simulazione processo dinamico sulla rete 
iter_last_change = 0;
convergenza = false;
iter = 0;
iter_max = 15000;
iter_min = 100;
x = randi([0,1],N,1); % Genrazione stato iniziale (0 denota OFF e 1 denota ON)
colori=[1 0 0;0 1 0];   % Rosso per gli OFF, Verde per gli ON
P.NodeColor = colori(x+1,:);
alfa_hat = sum(x)/N;
C = 1-abs(alfa-sum(x)/N); % Coordiantion level
hold on 
plot(NaN,NaN,'or','MarkerFaceColor',colori(1,:));
plot(NaN,NaN,'og','MarkerFaceColor',colori(2,:));
plot(NaN,NaN,'linestyle','none');
plot(NaN,NaN,'linestyle','none');
title({['Topologia rete Watts-Strogatz (N = ',num2str(N),', m = ',num2str(m),', \beta = ',num2str(p),')'];['\alpha = ',num2str(alfa),', t = ',num2str(iter)]});
leg = legend('Node OFF','Node ON',['$\hat{\alpha}$ = ',num2str(alfa_hat)],['C = ',num2str(C)],'Location','Best');
leg.FontSize = 14;
set(leg,'Interpreter','Latex');
legend('boxoff');
set(gca,'XTick',[]);
set(gca,'YTick',[]);   
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    frame = getframe(gcf);
%     writeVideo(v,frame);
end
fprintf('\nPremi un tasto per iniziare la simulazione \n');
pause();
xinit = x;
xvec = xinit;
h = waitbar(0,'We are at iteration 0','Name','Running simulation');
while(convergenza == false && iter < iter_max)
    iter = iter+1;
    waitbar(iter/iter_max,h,['We are at iteration ',num2str(iter)]);
    i = randi([1,N],1,1);
    vicini = neighbors(ws,i);
    chi = (x(i) + sum(x(vicini)))/(1+degree(ws,i));
    chi_hat = (1-x(i) + sum(x(vicini)))/(1+degree(ws,i));
    if(abs(alfa-chi_hat)<abs(alfa-chi))
        x(i)=1-x(i);
        iter_last_change = iter;
    end
    drawnow;
    P.NodeColor = colori(x+1,:);
    alfa_hat = sum(x)/N;
    C = 1-abs(alfa-sum(x)/N); % Coordiantion level
    hold on
    plot(NaN,NaN,'linestyle','none');
    plot(NaN,NaN,'linestyle','none');
    title({['Topologia rete Watts-Strogatz (N = ',num2str(N),', m = ',num2str(m),', \beta = ',num2str(p),')'];['\alpha = ',num2str(alfa),', t = ',num2str(iter)]});
    leg = legend('Node OFF','Node ON',['$\hat{\alpha}$ = ',num2str(alfa_hat)],['C = ',num2str(C)],'Location','Best');
    leg.FontSize = 14;
    set(leg,'Interpreter','Latex')
    legend('boxoff');
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
        frame = [frame; getframe(gcf)];
    %    writeVideo(v,frame);
    end
    pause(0.01)
    if(iter-iter_last_change >= 60 && iter>=iter_min)
        convergenza = true;
    end
    xvec = [xvec;x];
end

if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    duration = 20;
    v.FrameRate = ceil(numel(frame)/duration);
    open(v);
    for i = 1:numel(frame)
        writeVideo(v,frame(i));
    end
end

fprintf(['Il livello ottenuto è pari a ',num2str(alfa_hat),'\n']);

A = sum(abs(x-xinit))/N; % Alteration level

delete(h);
if(flag == 'yes' | flag == 'Yes' | flag == 'y' | flag == 'Y')
    close(v);
end