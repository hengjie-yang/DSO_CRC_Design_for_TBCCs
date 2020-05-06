% theoretical UER curve

% openfig('Plot_ISIT_2020_TBCC_FER_VS_SNR.fig');


SNR_dB = 0:0.25:8;
SNR = 10.^(SNR_dB/10);

UER_deg_10_suboptimal_TBCC_133_171 = 2*qfunc(sqrt(SNR.*14))+15*qfunc(sqrt(SNR.*16))+...
    639*qfunc(sqrt(SNR.*18))+3400*qfunc(sqrt(SNR.*20));


UER_deg_10_optimal_TBCC_133_171=10*qfunc(sqrt(SNR.*16))+...
    898*qfunc(sqrt(SNR.*18))+2970*qfunc(sqrt(SNR.*20));



semilogy(SNR_dB, UER_deg_10_suboptimal_TBCC_133_171,'-.');grid on, hold on
semilogy(SNR_dB, UER_deg_10_optimal_TBCC_133_171,'-*');
legend('v=6, m= 10, suboptimal, simulation',...
    'v=6, m=10, optimal, simulation',...
    'v=6, m= 10, suboptimal, theoretical',...
    'v=6, m=10, optimal, theoretical');


xlabel('SNR (dB)');
ylabel('UER');