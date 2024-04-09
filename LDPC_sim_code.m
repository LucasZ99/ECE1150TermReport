H = dvbs2ldpc(1/2);

cfgLDPCEnc = ldpcEncoderConfig(H);
cfgLDPCDec = ldpcDecoderConfig(H);

M = 2;
maxnumiter = 5;
snr = -10:0.1:10;
numframes = 10;

% Vector to store BER and SNR values
berVecBSC = zeros(length(snr));

ber = comm.ErrorRate;
ber2 = comm.ErrorRate;

for ii = 1:length(snr)
    for counter = 1:numframes
        data = randi([0 1],cfgLDPCEnc.NumInformationBits,1,'int8');
        % Transmit and receive with LDPC coding
        encodedData = ldpcEncode(data,cfgLDPCEnc);
        modSignal = pskmod(encodedData,M,InputType='bit');
        [rxsig, noisevar] = awgn(modSignal,snr(ii));
        demodSignal = pskdemod(rxsig,M, ...
            OutputType='approxllr', ...
            NoiseVariance=noisevar);
        rxbits = ldpcDecode(demodSignal,cfgLDPCDec,maxnumiter);
        errStats = ber(data,rxbits);
        % Transmit and receive with no LDPC coding
        noCoding = pskmod(data,M,InputType='bit');
        rxNoCoding = awgn(noCoding,snr(ii));
        rxBitsNoCoding = pskdemod(rxNoCoding,M,OutputType='bit');
        errStatsNoCoding = ber2(data,int8(rxBitsNoCoding));
        % Store BER for this frame
        berVecBSC(ii,:) = errStats(1);
    end
    fprintf(['SNR = %2d\n   Coded: Error rate = %1.2f, ' ...
        'Number of errors = %d\n'], ...
        snr(ii),errStats(1),errStats(2))
    fprintf(['Noncoded: Error rate = %1.2f, ' ...
        'Number of errors = %d\n'], ...
        errStatsNoCoding(1),errStatsNoCoding(2))
    reset(ber);
    reset(ber2);
end

% Uncoded BER
uncodedBER = berawgn(snr, 'psk', 2, 'nondiff');

% Plot BER as a function of SNR
semilogy( ...
    snr, berVecBSC(:,1),'b-', ...
    snr,uncodedBER,'-');
legend('Simulated LDPC BER','Uncoded BER', ...
    'Location','southwest');
xlabel("Eb/N0 (dB)");
ylabel("Error Probability");
title("Bit Error Probability");
grid on;
