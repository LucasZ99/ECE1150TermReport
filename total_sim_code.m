model = 'BCH_sim.slx';
open_system(model);

% compare theoretical error rate vs simulation error rate
EbNoVec = 0:1:10;

% Uncoded BER
uncodedBER = berawgn(EbNoVec, "psk", 2, "nondiff");

% theorBER will change depending on what kind of code you are generating
theorBER = bercoding(EbNoVec,'block','hard',7,4,3);

berVecBSC  = zeros(length(EbNoVec),3);
for n   = 1:length(EbNoVec)
    EbNo = EbNoVec(n);
    sim(model);
    berVecBSC(n,:) = berBSC(end,1);
end

% produce a semilog graph of coded, theoretical, and uncoded BER's
semilogy( ...
    EbNoVec,berVecBSC(:,1),'b*', ...
    EbNoVec,theorBER,'-',...
    EbNoVec, uncodedBER, '-');

legend('Simulated BSC BER','Theoretical BER','Uncoded BER',...
    Location="southwest");

xlabel("Eb/N0 (dB)");
ylabel("Error Probability");
title("Bit Error Probability");
grid on;