% theoretical UER curve of degree-6

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',14,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% openfig('Plot_ISIT_2020_small_example.fig');


SNR_dB = 0:0.25:5;
SNR = 10.^(SNR_dB/10);

UER_deg_6_suboptimal_TBCC_13_17 = 1*qfunc(sqrt(SNR.*7))+8*qfunc(sqrt(SNR.*11))+...
    198*qfunc(sqrt(SNR.*12))+758*qfunc(sqrt(SNR.*13))+1114*qfunc(sqrt(SNR.*14))+...
    2814*qfunc(sqrt(SNR.*15))+7375*qfunc(sqrt(SNR.*16))+18473*qfunc(sqrt(SNR.*17));

UER_deg_6_optimal_TBCC_13_17 = 735*qfunc(sqrt(SNR.*12))+2310*qfunc(sqrt(SNR.*14))+...
    13965*qfunc(sqrt(SNR.*16));




semilogy(SNR_dB, UER_deg_6_suboptimal_TBCC_13_17,'-.');grid on, hold on
semilogy(SNR_dB, UER_deg_6_optimal_TBCC_13_17,'-.');grid on, hold on
legend('v=3, m=6, suboptimal, theoretical',...
    'v=3, m=6, optimal, theoretical');
title('TBCC: [13,17], degree-6 CRCs, k = 64');


xlabel('SNR (dB)');
ylabel('UER');