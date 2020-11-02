% theoretical UER curve of degree-6
clear all; clc;
set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


% openfig('Plot_ISIT_2020_small_example.fig');

% Truncated union bounds
SNR_dB = 0:0.2:5;
SNR = 10.^(SNR_dB/10);

UER_deg_6_suboptimal_TBCC_13_17 = 1*qfunc(sqrt(SNR.*7))+8*qfunc(sqrt(SNR.*11))+...
    198*qfunc(sqrt(SNR.*12))+758*qfunc(sqrt(SNR.*13))+1114*qfunc(sqrt(SNR.*14))+...
    2814*qfunc(sqrt(SNR.*15))+7375*qfunc(sqrt(SNR.*16))+18473*qfunc(sqrt(SNR.*17));

UER_deg_6_optimal_TBCC_13_17 = 735*qfunc(sqrt(SNR.*12))+2310*qfunc(sqrt(SNR.*14))+...
    13965*qfunc(sqrt(SNR.*16));



% simulation data from Ethan Liang
tbcc_v3_m6_L_10_6 = [791/2000, 611/2000, 500/2073, 500/2634, 500/3744, 500/5238, 500/7413, 500/11030, 500/18729, 500/27082, 500/43766, 500/77466, 500/143099, 500/243554, 500/433647, 500/849309, 500/1558864, 500/3198848, 500/5991061, 500/11217080, 500/19978712, 500/36775373, 500/67136338, 500/118350384, 176/70000000];
tbcc_v3_m6_snr_L_10_6 = [0:0.2:4.8];


tbcc_v3_m6_L_10_6_optimal = [818/2000, 663/2000, 501/2000, 500/2584, 500/3315, 500/4991, 500/6552, 500/10279, 500/17368, 500/24019, 500/41159, 500/73571, 500/125028, 500/205409, 500/363932, 500/690948, 500/1378941, 500/2828738, 500/6142619, 500/12183508, 500/23570259, 500/53162794, 500/118485011, 190/110000000];
tbcc_v3_m6_snr_L_10_6_optimal = [0:0.2:4.6];





semilogy(SNR_dB, UER_deg_6_suboptimal_TBCC_13_17,'-.','Color',[0.4660, 0.6740, 0.1880],'LineWidth',2);grid on, hold on
semilogy(tbcc_v3_m6_snr_L_10_6, tbcc_v3_m6_L_10_6,'-o','Color',[0.4660, 0.6740, 0.1880]);hold on
semilogy(SNR_dB, UER_deg_6_optimal_TBCC_13_17,'-.','Color',[0.6350, 0.0780, 0.1840],'LineWidth',2);hold on
semilogy(tbcc_v3_m6_snr_L_10_6_optimal, tbcc_v3_m6_L_10_6_optimal, '-+','Color',[0.6350, 0.0780, 0.1840]);

xline(3.4,'--r');

legend('0x43, Truncated Union Bound',...
    '0x43, Simulation',...
    '0x63, Truncated Union Bound',...
    '0x63, Simulation');
% title('TBCC: [13,17], degree-6 CRCs, k = 64');


xlabel('$E_s/N_0$ (dB)','interpreter','latex');
ylabel('Undetected Error Rate');