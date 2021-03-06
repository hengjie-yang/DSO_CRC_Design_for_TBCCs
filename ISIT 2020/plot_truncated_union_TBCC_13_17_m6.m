% This script is to plot all truncated union bound of degree-6 CRC
% polynomials for TBCC [13, 17].
%
%


% Step 1: find the undetected distance spectra for all CRC candidates.
clear all; clc;
code_generator = [13, 17];
d_tilde = 18;
k = 64;
m = 6;
N = k + m;
base = 16;


List_size = 2^(m-1);

%%
Candidate_CRCs = dec2bin(0:List_size-1) - '0';
Candidate_CRCs = [ones(List_size,1), Candidate_CRCs, ones(2^(m-1),1)]; % degree order from highest to lowest
Candidate_poly_hex=dec2base(bin2dec(num2str(Candidate_CRCs)),base); % hex form
Undetected_spectra = zeros(List_size, d_tilde);

for iter = 1:List_size
    disp(['Current iteration: ',num2str(iter)]);
    crc_poly = Candidate_poly_hex(iter,:);
    dist_spec = Find_udist_spectrum_for_crc(code_generator, d_tilde, N, crc_poly);
    Undetected_spectra(iter,:) = dist_spec;
end

disp("Finished!");


%% Step 2: plot the truncated union bound;

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',16,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',16,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

snr_dB  = 1:0.2:7;
UER_union_bounds = zeros(List_size, size(snr_dB,2));
dists = 0:d_tilde-1;

% compute the UER union bound
for it = 1:List_size
    for iter = 1:size(snr_dB,2)
        snr = 10^(snr_dB(iter)/10);
        coefficients = Undetected_spectra(it,:);
        UER_union_bounds(it, iter) = sum(coefficients.*qfunc(sqrt(snr*dists)));
    end
end


% plot UER union bound
st = 11;

for iter = 1:List_size
    h = semilogy(snr_dB(st:end), UER_union_bounds(iter,st:end), '-.','LineWidth',0.5);hold on
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
semilogy(snr_dB(st:end), UER_union_bounds(2,st:end),'-o','LineWidth',2.0,'Color',[0.4660, 0.6740, 0.1880]);hold on
semilogy(snr_dB(st:end), UER_union_bounds(18,st:end),'-+','LineWidth',2.0,'Color',[0.6350, 0.0780, 0.1840]);hold on
xline(3.4,'--r');

legend('Suboptimal CRC 0x43','DSO CRC 0x63');
grid on;
xlabel('$E_s/N_0$ (dB)','interpreter','latex');
ylabel('Undetected Error Rate');
% title('The Truncated Union Bound of DSO CRCs of degree-6');

    





    

