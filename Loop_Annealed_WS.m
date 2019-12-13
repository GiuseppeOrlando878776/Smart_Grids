clc;
close all;
clear all;
%% Generazione e Visualizzazione della rete
fprintf('Stiamo simulando una rete Watts-Strogatz \n');
N = input('\nInserisci il numero di nodi desiderati: ');
m = input('Inserisci il numero di vicini di nodo desiderati: ');
alfa = input('Inserisci la percentuale di utenti on desiderata: ');
p1 = 1e-4;
p2 = 2e-4;
p3 = 4e-4;
p4 = 6.85e-4;
p5 = 8.85e-4;
p6 = linspace(1e-3,1e-2,15);
p7 = linspace(1e-2,1e-1,15);
p8 = linspace(1e-1,1,20);
ptest = union(p1,p2);
ptest = union(ptest,p3);
ptest = union(ptest,p4);
ptest = union(ptest,p5);
ptest = union(ptest,p6);
ptest = union(ptest,p7);
ptest = union(ptest,p8);
totp = numel(ptest);
nump = 0;
bar = waitbar(0,'We are at iteration 0','Name','Checking p');
C = [];
A = [];
for p = ptest
    nump = nump + 1;
    waitbar(nump/totp,bar,['We are at iteration ',num2str(nump)]);
    hp = waitbar(0,'We are at iteration 0','Name','Running networks');
    C_var = [];
    A_var = [];
    for inner = 1:10
        waitbar(inner/10,hp,['We are at iteration ',num2str(inner)]);
        ws = WattsStrogatz(N,m,p);
%     while(max(max(distances(er))==Inf)) % Genero una rete connessa
%         ER = generateER(N,k);
%         er = graph(ER);
%     end
%   figure()
%   P = plot(er);
%   title('Topologia della rete Erdos-Renyi generata');
%   MeanDegree = mean(degree(er));
%   fprintf(['Il grado medio ottenuto e'' ',num2str(MeanDegree),'\n']);

%% Simulazione processo dinamico sulla rete 
    %deg = er.degree; % Salvo la distribuzione di grado 

        x = randi([0,1],N,1); % Genrazione stato iniziale (0 denota OFF e 1 denota ON)
%     colori=[1 0 0;0 1 0];   % Rosso per gli infetti, Verde per i suscettibili
%     P.NodeColor = colori(x,:);
%     hold on
%     plot(NaN,NaN,'or','MarkerFaceColor',colori(1,:));
%     plot(NaN,NaN,'og','MarkerFaceColor',colori(2,:));
%     legend('Node OFF','Node ON','Location','Best');
%     legend('boxoff');
%     fprintf('\nPremi un tasto per iniziare la simulazione \n');
%     pause();
        xinit = x;
%         C_hat = 1-abs(alfa-sum(x)/N);
%         A_hat = sum(abs((x)-(xinit)))/N;
        iter_last_change = 0;
        convergenza = false;
        iter = 0;
        iter_max = 10000;
        iter_min = 100;
        hrete = waitbar(0,'We are at iteration 0','Name','Running simulation');
        while(convergenza == false && iter < iter_max)
            xold = x;
%             A_hat_old = A_hat;
%             C_hat_old = C_hat;
            iter = iter+1;
            waitbar(iter/iter_max,hrete,['We are at iteration ',num2str(iter)]);
            i = randi([1,N],1,1);
            tmp1 = 1:i-1;
            tmp2 = i+1:N;
            tmp = union(tmp1,tmp2);
            vicini = datasample(tmp,degree(ws,i),'Replace',false);
            chi = (x(i) + sum(x(vicini)))/(1+degree(ws,i));
            chi_hat = (1-x(i) + sum(x(vicini)))/(1+degree(ws,i));
            if(abs(alfa-chi_hat)<abs(alfa-chi))
                x(i)=1-xold(i);
            %    iter_last_change = iter;
            end
            if(sum(xold)~= sum(x))
                iter_last_change = iter;
            end
%     drawnow;
%     P.NodeColor = colori(x,:);
%     pause(0.01)
            if(iter-iter_last_change >= 30 && iter>=iter_min)
                convergenza = true;
            end
%             C_hat = 1-abs(alfa-sum(x)/N);
%             A_hat = sum(abs((x)-(xinit)))/N;
%             if(abs(A_hat-A_hat_old)<1e-2 && abs(C_hat-C_hat_old)<1e-2)
%                 convergenza = true;
%             end
        end
%         alfa_hat = sum(x)/N;
        C_var = [C_var;1-abs(alfa-sum(x)/N)]; % Coordiantion level
        A_var = [A_var;sum(abs(x-xinit))/N]; % Alteration level
        delete(hrete);
    end
    C = [C;mean(C_var)];
    A = [A;mean(A_var)];
    delete(hp);
end
delete(bar);
str = num2str(alfa);
figure()
semilogx(ptest,C,'ko--','MarkerEdgeColor','k','MarkerFaceColor','r');
xlabel('\beta')
ylabel('C')
ylim([0.67 1])
title(['Coordination Level(N=',num2str(N),',m=',num2str(m),',\alpha=',str,')'])
legend('Annealed Network','Location','Best')
legend('boxoff')
print(['C_Loop_Annealed_WS(0,',str(3:end),')'],'-dpng','-r300')
figure()
semilogx(ptest,A,'ko--','MarkerEdgeColor','k','MarkerFaceColor','b');
ylim([0.17 0.63])
xlabel('\beta')
ylabel('A')
title(['Alteration Level(N=',num2str(N),',m=',num2str(m),',\alpha=',str,')'])
legend('Original Model','Location','Best')
legend('boxoff')
print(['A_Loop_Annealed_WS(0,',str(3:end),')'],'-dpng','-r300')
save(['Loop_Annealed_WS(0,',str(3:end),').mat'])