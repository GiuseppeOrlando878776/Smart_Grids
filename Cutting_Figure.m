ptest_ann = [1e-6 ptest_ann];
C_ann = [alfa;C_ann];
A_ann = [0.5;A_ann];
str = num2str(alfa);
figure()
semilogx(ptest_ann,C_ann,'ko--','MarkerEdgeColor','k','MarkerFaceColor','r');
xlabel('p')
ylabel('C')
ylim([0.67 1])
title(['Coordination Level(\alpha=',str,')'])
legend('Annealed Network','Location','Best')
legend('boxoff')
ax = gca;
ax.XTickLabel{1} = 0;
ax.XTickLabel{2} = '';
ax.XTickLabel{end} = 1;
print(['CutC_Loop_Annealed(0,',str(3:end),')'],'-dpng','-r300')
figure()
semilogx(ptest_ann,A_ann,'ko--','MarkerEdgeColor','k','MarkerFaceColor','b');
ylim([0.17 0.63])
xlabel('p')
ylabel('A')
title(['Alteration Level(\alpha=',str,')'])
legend('Annealed Network','Location','Best')
legend('boxoff')
ax = gca;
ax.XTickLabel{1} = 0;
ax.XTickLabel{2} = '';
ax.XTickLabel{end} = 1;
print(['CutA_Loop_Annealed(0,',str(3:end),')'],'-dpng','-r300')
