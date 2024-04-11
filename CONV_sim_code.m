model = 'CONV_sim.slx';
load_system(model);

% compare theoretical error rate vs simulation error rate
EbNoVec = 0:1:7;

% Uncoded BER
uncodedBER = berawgn(EbNoVec, "psk", 2, "nondiff");

trellis = poly2trellis(7, [171, 133]);

spect = distspec(trellis, 6);

% theorBER will change depending on what kind of code you are generating
theorBER = bercoding(EbNoVec,'conv','hard', 1/2, spect);

berVecBSC  = zeros(length(EbNoVec),3);
for n   = 1:(length(EbNoVec))
    EbNo = EbNoVec(n);
    sim(model);
    berVecBSC(n,:) = berBSC(end,1);
end

% produce a semilog graph of coded, theoretical, and uncoded BER's
semilogy(  ...
    EbNoVec,berVecBSC(:,1),'b*', ...
    EbNoVec,theorBER,'-',...
    EbNoVec, uncodedBER, '-');
    

legend('Simulated CONV BER','Theoretical BER','Uncoded BER',...
    Location="southwest");

xlabel("Eb/N0 (dB)");
ylabel("Error Probability");
title("Bit Error Probability");
grid on;