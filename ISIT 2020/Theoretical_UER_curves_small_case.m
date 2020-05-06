% theoretical UER curve

openfig('Plot_ISIT_2020_small_example.fig');


SNR_dB = 0:0.25:5;
SNR = 10.^(SNR_dB/10);

UER_deg_3_optimal_TBCC_13_17 = 66*qfunc(sqrt(SNR.*8))+96*qfunc(sqrt(SNR.*10))+...
    184*qfunc(sqrt(SNR.*12))+96*qfunc(sqrt(SNR.*14))+69*qfunc(sqrt(SNR.*16));





semilogy(SNR_dB, UER_deg_3_optimal_TBCC_13_17,'-.');grid on, hold on
legend('v=3, m=3, optimal, simulation',...
    'v=3, m=3, optimal, theoretical');
title('TBCC: [13,17], degree-3 DSO CRC: (F), k=9 bits');


xlabel('SNR (dB)');
ylabel('UER');