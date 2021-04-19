% This script is to verify the gap between the simulated P_UE and the
% truncated union bound (TUB). Especially, we would like to see if the order of
% the TUB aligns with that of the simulated P_UE.
%
% The example studied here is k = 64, m = 4, TBCC (133,171), d_tilde = 21.
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   04/16/21
%


% % Step 1: Load system parameters
k = 64;
m = 4;
N = k + m;
d_tilde = 21;
code_generator = [133, 171];

% code_string = '';
% for iter = 1:length(code_generator)
%     code_string = [code_string, num2str(code_generator(iter)), '_'];
% end
% 
% file_name = ['TBP_node_TBCC_',code_string,'d_',num2str(d_tilde),'_N_',num2str(N),'.mat'];
% if ~exist(file_name, 'file')
%     disp(['Error: the file ',file_name, ' does not exist!']);
%     return
% end
% load(file_name, 'TBP_node');


List_size = 2^(m-1);
Candidate_CRCs = dec2bin(0:List_size-1) - '0';
Candidate_CRCs = [ones(List_size,1), Candidate_CRCs, ones(2^(m-1),1)]; % degree order from highest to lowest
Candidate_poly_octals=dec2base(bin2dec(num2str(Candidate_CRCs)), 8); % octal form

disp('Step 1 completed!');





% Step 2: Compute the TUB

% Truncated_undetected_spectra = zeros(d_tilde, List_size); % each column is a TUB
% 
% for iter = 1:List_size
%     disp(['Processing progress: ', num2str(iter), ' out of ', num2str(List_size)]);
%     candidate_CRC_octal = Candidate_poly_octals(iter, :);
%     Truncated_undetected_spectra(:,iter) = Compute_truncated_undetected_spectrum(code_generator, d_tilde, N, candidate_CRC_octal, 8);
% end
% 
% disp('Step 2 completed!');

fileName = 'Truncated_undetected_spectra_TBCC_133_171_CRC_m_4_k_64';
load([fileName, '.mat'], 'Truncated_undetected_spectra');


%% Step 3: Plot the TUBs


% Load simulation data
SNR_dBs = cell(8, 1);
P_UEs = cell(8, 1);

fileName = '041621_163607_sim_data_vs_SNR_TBCC_133_171_CRC_21_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{1} = SNRs;
P_UEs{1} = P_UE_maxs;

fileName = '041621_163737_sim_data_vs_SNR_TBCC_133_171_CRC_23_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{2} = SNRs;
P_UEs{2} = P_UE_maxs;

fileName = '041621_163813_sim_data_vs_SNR_TBCC_133_171_CRC_25_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{3} = SNRs;
P_UEs{3} = P_UE_maxs;

fileName = '041621_163838_sim_data_vs_SNR_TBCC_133_171_CRC_27_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{4} = SNRs;
P_UEs{4} = P_UE_maxs;

fileName = '041621_164018_sim_data_vs_SNR_TBCC_133_171_CRC_31_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{5} = SNRs;
P_UEs{5} = P_UE_maxs;

fileName = '031521_182059_sim_data_vs_SNR_TBCC_133_171_CRC_33_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{6} = SNRs;
P_UEs{6} = P_UE_maxs;

fileName = '041621_164136_sim_data_vs_SNR_TBCC_133_171_CRC_35_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{7} = SNRs;
P_UEs{7} = P_UE_maxs;

fileName = '041621_164209_sim_data_vs_SNR_TBCC_133_171_CRC_37_k_64';
load([fileName, '.mat'], 'P_UE_maxs', 'SNRs');
SNR_dBs{8} = SNRs;
P_UEs{8} = P_UE_maxs;



snr_dBs = 1:0.5:3;
dists = 0:1:(d_tilde-1);

TUBs = zeros(List_size, length(snr_dBs));

for ii = 1:List_size
    for iter = 1:length(snr_dBs)
        A = sqrt(10^(snr_dBs(iter)/10));
        temp = Truncated_undetected_spectra(:,ii)';
        TUBs(ii, iter) = sum(temp.*qfunc(A*sqrt(dists)));
    end
end

figure;
% semilogy(snr_dBs, TUBs(1, :), '-.','Color','#0072BD');hold on
% semilogy(SNR_dBs{1}, P_UEs{1}, '-','Color','#0072BD'); hold on
% 
% semilogy(snr_dBs, TUBs(2, :), '-.','Color','#D95319');hold on
% semilogy(SNR_dBs{2}, P_UEs{2}, '-','Color','#D95319'); hold on
% 
% semilogy(snr_dBs, TUBs(3, :), '-.','Color','#EDB120');hold on
% semilogy(SNR_dBs{3}, P_UEs{3}, '-','Color','#EDB120'); hold on
% 
% semilogy(snr_dBs, TUBs(4, :), '-.','Color','#7E2F8E');hold on
% semilogy(SNR_dBs{4}, P_UEs{4}, '-','Color','#7E2F8E'); hold on
% 
% semilogy(snr_dBs, TUBs(5, :), '-.','Color','#77AC30');hold on
% semilogy(SNR_dBs{5}, P_UEs{5}, '-','Color','#77AC30'); hold on

semilogy(snr_dBs, TUBs(6, :), '-.','Color','#4DBEEE');hold on
semilogy(SNR_dBs{6}(1:end-1), P_UEs{6}(1:end-1), '-o','Color','#4DBEEE'); hold on

semilogy(snr_dBs, TUBs(7, :), '-.','Color','#FF0000');hold on
semilogy(SNR_dBs{7}, P_UEs{7}, '-o','Color','#FF0000'); hold on

semilogy(snr_dBs, TUBs(8, :), '-.','Color','#0000FF');hold on
semilogy(SNR_dBs{8}, P_UEs{8}, '-o','Color','#0000FF'); hold on

% legend('CRC (21)',...
%     'CRC (23)',...
%     'CRC (25)',...
%     'CRC (27)',...
%     'CRC (31)',...
%     'CRC (33)',...
%     'CRC (35)',...
%     'CRC (37)');

xlim([1,3]);
grid on
xlabel('SNR (dB)');
        

















