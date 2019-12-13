clc;
clear all;
close all;
%% Lettura parametri
N = input('\nInserisci il numero di nodi desiderati: ');
alpha = input('Inserisci la percentuale di utenti on desiderata: ');
%% Initial Guess
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
bar = waitbar(0,'We are at iteration 0','Name','Running simulation');
C_hat = [];
for p = ptest
    nump = nump + 1;
    waitbar(nump/totp,bar,['We are at iteration ',num2str(nump)]);
    %% Inizializzazione
    x = round(alpha*N);
    xold = x;
    %% Ciclo punto fisso
    h = waitbar(0,'We are at iteration 0','Name','Running simulation on each p');
    iter = 0;
    iter_max = 500;
    convergenza = false;
    while(convergenza == false && iter < iter_max)
        h1 = waitbar(0,'We are at iteration 0','Name','Checking k');    
        iter = iter+1;
        waitbar(iter/iter_max,h,['We are at iteration ',num2str(iter)]);
        x2old = xold;
        xold = x;
        p01 = 0;
        p10 = 0;
        f = 0;
        fbar = 0;
        for k = 0:N-1
            waitbar(k/(N-1),h1,['We are at iteration ',num2str(k)]);
            for nu = max(0,k+floor(xold)-N):min(k,floor(xold))
                f = f + (hygepdf(nu,N-1,floor(xold),k)*(1-heaviside(abs(alpha-(1+nu)/(1+k))-abs(alpha-nu/(1+k)))));
            end
            p01 = p01 + (binopdf(k,N-1,p)*f);
            for nu = max(0,k+(floor(xold)-1-N)):min(k,floor(xold)-1)
                fbar = fbar + (hygepdf(nu,N-1,floor(xold)-1,k)*(1-heaviside(abs(alpha-nu/(1+k))-abs(alpha-(1+nu)/(1+k)))));
            end
            p10 = p10 + (binopdf(k,N-1,p)*fbar);
        end
        delete(h1);
        x = N*p01/(p01+p10);         
%         fprintf(['Il valore ottenuto è pari a ',num2str(x),'\n']);
        if(x2old == x)
            convergenza = true;
        end
    end
    C_hat = [C_hat;max(1-abs(alpha-floor(x)/N),1-abs(alpha-floor(xold)/N))];
    fprintf(['Il valore di coordinazione ottenuto è pari a ',num2str(C_hat(end)),'\n']);
    delete(h);
end
delete(bar)
str = num2str(alpha);
figure()
semilogx(ptest,C_hat,'ko--','MarkerEdgeColor','k','MarkerFaceColor','r');
xlabel('p')
ylabel('C')
ylim([0.67 1])
title(['Coordination Level(\alpha=',str,')'])
legend('Analytical','Location','Best')
legend('boxoff')
print(['C_Loop_Analytical(0,',str(3:end),')'],'-dpng','-r300')
save(['Loop_Analytical(0,',str(3:end),').mat'])