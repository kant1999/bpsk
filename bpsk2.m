clear;
clc;
close all;

% define a SNR vector you want to simulate
SNR_range = -10:1:15;
BER = zeros(1,length(SNR_range));

for ii = 1:length(SNR_range)

data_tx = rand(1,1000000); %create random data to be transmitted
data_tx = round(data_tx); %round up value to 1 or 0 -> data is like 0101110

%mapping matrix -> for modulation purpose
sym_map = [1, -1];
M = log2(length(sym_map)); %no. of bits for representing the modulation
temp = reshape(data_tx,M,[]); %reshaping matrix, e.g. 2x4 -> 4x2
sym_int = 2.^[0:M-1]*temp; %init symbol matrix based on reshaped data_tx
sym_int = sym_int+1; %add one to cover full 4 cases start from 1 instead 0
sym_tx = sym_map(sym_int); %apply map to sym_int, this is modulation

SNR = SNR_range(ii); %signal to noise ratio, unit = dB
Esig2 = 10^(-SNR/20); %avg amplitude of noise

%generate noise
n = size(sym_tx);
noise = Esig2*(randn(n)+j*randn(n))/sqrt(2);

%add noise to tx and form rx
sym_rx = sym_tx + noise;

%demodulation, using slicer
tmp = sym_rx<0;
%reshaping matrix
data_rx = reshape(tmp,1,[]);

BE = sum(data_tx ~= data_rx); %sum of bit errors

BER(ii) = BE/length(data_rx); %bit error rate = no. of error bits / lenght data
end

%plot graph
figure(1);
semilogy(SNR_range,BER,'b-');xlabel('SNR (dB)');ylabel('BER');title('BPSK AWGN');grid on
