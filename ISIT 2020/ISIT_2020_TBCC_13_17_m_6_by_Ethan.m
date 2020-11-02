clear;clc; close all;

%Dat Data
rcu_64_140 = [0.318052016521905	0.268557216261977	0.224254237239571	0.185097126213304	0.150938489119897	0.121541383064785	0.0965943043119596	0.0757283412729153	0.0585354257471226	0.0445865748971060	0.0334490744738189	0.0247017024500074	0.0179473123529095	0.0128223599733459	0.00900323444764414	0.00620951413829713	0.00420448325858712	0.00279339886208512	0.00182008156156344	0.00116241893115240	0.000727328071183069	0.000445638994637141	0.000267251476106749	0.000156802305017005	8.99719854430826e-05	5.04698392143987e-05	2.76693504044402e-05	1.48222203003087e-05	7.75747297563844e-06	3.96658449767069e-06	1.98181924537750e-06	9.67844199528499e-07	4.62260979255819e-07	2.16115314145826e-07	9.90237739127370e-08	4.45442114973382e-08	1.97166789312362e-08	8.98017194472295e-09	4.40466443066992e-09	2.02301603385747e-09	8.92471088354575e-10	3.83527048806959e-10	1.61979605289546e-10	6.76489592288209e-11	2.80650488505592e-11	1.16056796091776e-11	4.79657424001419e-12	1.98539765548612e-12	8.24379776501996e-13	3.43825660722769e-13	1.44195192110343e-13];
rcu_snr = [0	0.100000000000000	0.200000000000000	0.300000000000000	0.400000000000000	0.500000000000000	0.600000000000000	0.700000000000000	0.800000000000000	0.900000000000000	1	1.10000000000000	1.20000000000000	1.30000000000000	1.40000000000000	1.50000000000000	1.60000000000000	1.70000000000000	1.80000000000000	1.90000000000000	2	2.10000000000000	2.20000000000000	2.30000000000000	2.40000000000000	2.50000000000000	2.60000000000000	2.70000000000000	2.80000000000000	2.90000000000000	3	3.10000000000000	3.20000000000000	3.30000000000000	3.40000000000000	3.50000000000000	3.60000000000000	3.70000000000000	3.80000000000000	3.90000000000000	4	4.10000000000000	4.20000000000000	4.30000000000000	4.40000000000000	4.50000000000000	4.60000000000000	4.70000000000000	4.80000000000000	4.90000000000000	5];



% Suboptimal TBCC/CRC design
tbcc_v3_m6_L_10_6 = [791/2000, 611/2000, 500/2073, 500/2634, 500/3744, 500/5238, 500/7413, 500/11030, 500/18729, 500/27082, 500/43766, 500/77466, 500/143099, 500/243554, 500/433647, 500/849309, 500/1558864, 500/3198848, 500/5991061, 500/11217080, 500/19978712, 500/36775373, 500/67136338, 500/118350384, 176/70000000];
tbcc_v3_m6_snr_L_10_6 = [0:0.2:4.8];
tbcc_v3_m6_snr_L_10_6_bound = [0:0.2:5];
rcu_suboptimal = [0.318052016521905	0.224254237239571	0.150938489119897	0.0965943043119596	0.0585354257471226	0.0334490744738189	0.0179473123529095	0.00900323444764414	0.00420448325858712	0.00182008156156344	0.000727328071183069	0.000267251476106749	8.99719854430777e-05	2.76693504044402e-05	7.75747297563844e-06	1.98181924537750e-06	4.62260979255816e-07	9.90237739127370e-08	1.97166789312362e-08	4.40466443066992e-09	8.92471088354575e-10	1.61979605289552e-10	2.80650488505592e-11	4.79657424001419e-12	8.24379776501996e-13];
rcu_suboptimal_snr = [0	0.200000000000000	0.400000000000000	0.600000000000000	0.800000000000000	1	1.20000000000000	1.40000000000000	1.60000000000000	1.80000000000000	2	2.20000000000000	2.40000000000000	2.60000000000000	2.80000000000000	3	3.20000000000000	3.40000000000000	3.60000000000000	3.80000000000000	4	4.20000000000000	4.40000000000000	4.60000000000000	4.80000000000000];

tbcc_v3_m6_L_10_6_optimal = [818/2000, 663/2000, 501/2000, 500/2584, 500/3315, 500/4991, 500/6552, 500/10279, 500/17368, 500/24019, 500/41159, 500/73571, 500/125028, 500/205409, 500/363932, 500/690948, 500/1378941, 500/2828738, 500/6142619, 500/12183508, 500/23570259, 500/53162794, 500/118485011, 190/110000000];
tbcc_v3_m6_snr_L_10_6_optimal = [0:0.2:4.6];
tbcc_v3_m6_snr_L_10_6_optimal_bound = [0:0.2:5];
rcu_optimal = [0.318052016521905	0.224254237239571	0.150938489119897	0.0965943043119596	0.0585354257471226	0.0334490744738189	0.0179473123529095	0.00900323444764414	0.00420448325858712	0.00182008156156344	0.000727328071183069	0.000267251476106749	8.99719854430831e-05	2.76693504044402e-05	7.75747297563844e-06	1.98181924537745e-06	4.62260979255816e-07	9.90237739127370e-08	1.97166789312362e-08	4.40466443066992e-09	8.92471088354564e-10	1.61979605289552e-10	2.80650488505592e-11	4.79657424001419e-12];
rcu_optimal_snr = [0	0.200000000000000	0.400000000000000	0.600000000000000	0.800000000000000	1	1.20000000000000	1.40000000000000	1.60000000000000	1.80000000000000	2	2.20000000000000	2.40000000000000	2.60000000000000	2.80000000000000	3.00000000000000	3.20000000000000	3.40000000000000	3.60000000000000	3.80000000000000	4.00000000000000	4.20000000000000	4.40000000000000	4.60000000000000];

tbcc_v3_RCUGap = [];
tbcc_v3_RCUGap_optimal = [];

listOfFERS = logspace(-1.5, -5.5, 9);
for iter = 1:length(listOfFERS)
    tbcc_v3_RCUGap = [tbcc_v3_RCUGap, ComputeRCUGap(tbcc_v3_m6_L_10_6, rcu_suboptimal, rcu_suboptimal_snr, listOfFERS(iter))];
    tbcc_v3_RCUGap_optimal = [tbcc_v3_RCUGap_optimal, ComputeRCUGap(tbcc_v3_m6_L_10_6_optimal, rcu_optimal, rcu_optimal_snr, listOfFERS(iter))];
end


%Plotting variables
width = 800;
height = 600;
lineWidth = 1.5;
marker_list = ["-o","-x","-s",":o",":x",":s","-.o","-.x","-.s"];
labelTextSize = 18;
legendTextSize = 10;


set(0,'DefaultTextFontName','Times','DefaultTextFontSize',legendTextSize,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',labelTextSize,...
    'DefaultLineLineWidth',1.5,'DefaultLineMarkerSize',10);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
markerSize = 6;


%Plot FER vs. SNR
if (1)
    figure;
    my_colors = get(gca, "ColorOrder");
    semilogy(-3,-3, "o", 'Color', my_colors(1,:)); hold on;
    semilogy(-3,-3, "x", 'Color', my_colors(2,:));
    %semilogy(-3,-3, "s", 'Color', my_colors(5,:));
    semilogy(-3,-3, "-k");
    semilogy(-3,-3, "--k");
    semilogy(-3,-3, ":k");
    
    fer_approx_ztcc_v3_m6 = 1.*qfunc(sqrt(7)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10)))+...
        8.*qfunc(sqrt(11)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10)))+...
        198.*qfunc(sqrt(12)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10)))+...
        758.*qfunc(sqrt(13)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10)))+...
        1114.*qfunc(sqrt(14)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10))) + ...
        2814.*qfunc(sqrt(15)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10))) + ...
        7375.*qfunc(sqrt(16)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10))) + ...
        18473.*qfunc(sqrt(17)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_bound/10)));
    
    fer_approx_tbcc_v3_m6 = 735.*qfunc(sqrt(12)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_optimal_bound/10)))+...
        2310.*qfunc(sqrt(14)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_optimal_bound/10)))+...
        13965.*qfunc(sqrt(16)*sqrt(10.^(tbcc_v3_m6_snr_L_10_6_optimal_bound/10)));
    
    %semilogy(tbcc_v6_m0_snr_L_10_6, tbcc_v6_m0_L_10_6, marker_list(1), 'Color', my_colors(1,:), 'LineWidth', lineWidth, 'MarkerSize', markerSize); hold on;
    semilogy(tbcc_v3_m6_snr_L_10_6, tbcc_v3_m6_L_10_6, '-o', 'Color', my_colors(1,:), 'MarkerSize', 6);
    semilogy(tbcc_v3_m6_snr_L_10_6_optimal, tbcc_v3_m6_L_10_6_optimal, '-x', 'Color', my_colors(2,:), 'MarkerSize', 6);
    semilogy(tbcc_v3_m6_snr_L_10_6_bound, fer_approx_ztcc_v3_m6, '--', 'Color', my_colors(1,:));
    semilogy(tbcc_v3_m6_snr_L_10_6_optimal_bound, fer_approx_tbcc_v3_m6, '--', 'Color', my_colors(2,:));
    
    grid on;
    
    ylabel('Undetected Error Rate', 'interpreter', 'latex', 'FontSize', labelTextSize);
    xlabel("SNR(dB)", 'interpreter', 'latex', 'FontSize', labelTextSize);
    legend(...
        "ZTCC Design: $v=3$, $m=6$",...
        "TBCC Design: $v=3$, $m=6$",...
        "Simulated",...
        "Truncated Union Bound",...
        'location', 'NorthEast', 'interpreter', 'latex', 'FontSize', legendTextSize);
    xlim([0,5]);
    ylim([10^-6, 10^0]);
    set(gcf,'position', [10,10,width,height]);
    set(gca,'FontSize',legendTextSize);
    saveas(gcf, "Plot_ISIT_2020_small_example");
    set(gcf, 'Color', 'none');
    export_fig Plot_ISIT_2020_small_example.pdf -pdf -transparent
end


%Plot FER vs. RCU-Gap
if (1)
    figure;
    my_colors = get(gca, "ColorOrder");
    semilogy(-3,-3, "-o", 'Color', my_colors(1,:)); hold on;
    semilogy(-3,-3, "-x", 'Color', my_colors(2,:));
    %semilogy(-3,-3, "-k");
    %semilogy(-3,-3, "-.k");
    
    
    semilogy(tbcc_v3_RCUGap, listOfFERS, '-o', 'Color', my_colors(1,:), 'LineWidth', lineWidth, 'MarkerSize', markerSize); hold on;
    semilogy(tbcc_v3_RCUGap_optimal, listOfFERS, '-x', 'Color', my_colors(2,:), 'LineWidth', lineWidth, 'MarkerSize', markerSize);
    grid on;
    
    ylabel('Undetected Error Rate', 'interpreter', 'latex', 'FontSize', labelTextSize);
    xlabel("Gap to RCU bound (dB)", 'interpreter', 'latex', 'FontSize', labelTextSize);
    legend(...
        "ZTCC Design: $v=3$, $m=6$",...
        "TBCC Design: $v=3$, $m=6$",...
        'location', 'NorthEast', 'interpreter', 'latex', 'FontSize', legendTextSize);
    xlim([0.5, 1.8]);
    ylim([10^-6, 10^-1]);
    set(gcf,'position', [10,10,width,height]);
    set(gca,'FontSize',legendTextSize);
    saveas(gcf, "Plot_ISIT_2020_TBCC_FER_VS_RCU_v3_m6");
    set(gcf, 'Color', 'none');
    export_fig Plot_ISIT_2020_TBCC_FER_VS_RCU_v3_m6.pdf -pdf -transparent
end



