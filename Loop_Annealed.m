clc;
close all;
clear all;
%% Generazione e Visualizzazione della rete
fprintf('Stiamo simulando una rete Erdos-Renyi \n');
N = input('\nInserisci il numero di nodi desiderati: ');
alfa = input('Inserisci la percentuale di utenti on desiderata: ');
p1 = 1e-4;
p2 = 2e-4;
p3 = 4e-4;
p4 = 6.85e-4;
p5 = 8.85e-4;
p6 = linspace(1e-3,1e-2,15);
p7 = linspace(1e-2,1e-1,15);
p8 = linspace(1e-1,1,20);
ptest_ann = union(p1,p2);
ptest_ann = union(ptest_ann,p3);
ptest_ann = union(ptest_ann,p4);
ptest_ann = union(ptest_ann,p5);
ptest_ann = union(ptest_ann,p6);
ptest_ann = union(ptest_ann,p7);
ptest_ann = union(ptest_ann,p8);
k_ann = ptest_ann*(N-1);
for i=1:numel(ptest_ann)
    if(ptest_ann(i)>=1e-3)
        k_ann(i) = round(k_ann(i));
    end
end
ptest_ann = k_ann/(N-1);
totp = numel(ptest_ann);
nump = 0;
bar = waitbar(0,'We are at iteration 0','Name','Checking p');
C_ann = [];
A_ann = [];
for p = ptest_ann
    nump = nump + 1;
    waitbar(nump/totp,bar,['We are at iteration ',num2str(nump)]);
    hp = waitbar(0,'We are at iteration 0','Name','Running networks');
    C_var = [];
    A_var = [];
    for inner = 1:10
        waitbar(inner/10,hp,['We are at iteration ',num2str(inner)]);
        ER = generateER(N,k_ann(nump));
        er = graph(ER);
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
        iter_last_change = 0;
        convergenza = false;
        iter = 0;
        iter_max = 15000;
        iter_min = 100;
        hrete = waitbar(0,'We are at iteration 0','Name','Running simulation');
        while(convergenza == false && iter < iter_max)
            xold = x;
            iter = iter+1;
            waitbar(iter/iter_max,hrete,['We are at iteration ',num2str(iter)]);
            i = randi([1,N],1,1); 
            tmp1 = 1:i-1;
            tmp2 = i+1:N;
            tmp = union(tmp1,tmp2);
            vicini = datasample(tmp,degree(er,i),'Replace',false);
            chi = (x(i) + sum(x(vicini)))/(1+degree(er,i));
            chi_hat = (1-x(i) + sum(x(vicini)))/(1+degree(er,i));
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
        end
%         alfa_hat = sum(x)/N;
        C_var = [C_var;1-abs(alfa-sum(x)/N)]; % Coordiantion level
        A_var = [A_var;sum(abs((x)-(xinit)))/N]; % Alteration level
        delete(hrete);
    end
    C_ann = [C_ann;mean(C_var)];
    A_ann = [A_ann;mean(A_var)];
    delete(hp);
end
delete(bar);
str = num2str(alfa);
figure()
semilogx(ptest_ann,C_ann,'ko--','MarkerEdgeColor','k','MarkerFaceColor','r');
ylim([0.67 1])
xlabel('p')
ylabel('C')
title(['Coordination Level(\alpha=',str,')'])
legend('Annealed Network','Location','Best')
legend('boxoff')
print(['C_Loop_Annealed(0,',str(3:end),')'],'-dpng','-r300')
figure()
semilogx(ptest_ann,A_ann,'ko--','MarkerEdgeColor','k','MarkerFaceColor','b');
ylim([0.17 0.63])
xlabel('p')
ylabel('A')
title(['Alteration Level(\alpha=',str,')'])
legend('Annealed Network','Location','Best')
legend('boxoff')
print(['A_Loop_Annealed(0,',str(3:end),')'],'-dpng','-r300')
save(['Loop_Annealed(0,',str(3:end),').mat'])