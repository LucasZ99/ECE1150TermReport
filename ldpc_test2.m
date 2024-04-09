% Define parameters
H = dvbs2ldpc(1/2); % Parity check matrix
K = size(H, 2) - size(H, 1); % Length of the information word
numFrames = 100; % Number of frames to simulate

% Initialize error and bit counters
numErrors = 0;
numBits = 0;

% Create LDPC encoder and decoder
hEnc = comm.LDPCEncoder('ParityCheckMatrix', H);
hDec = comm.LDPCDecoder('ParityCheckMatrix', H, 'OutputValue', 'Whole codeword');

% Create error rate calculator
hErrorCalc = comm.ErrorRate;

for frame = 1:numFrames
    % Generate random binary data
    data = randi([0 1], K, 1);

    % Encode the data
    encodedData = step(hEnc, data);

    % Decode the encoded data
    decodedData = step(hDec, encodedData);

    % Calculate the error rate
    errorStats = step(hErrorCalc, data, decodedData(1:K));

    % Update error and bit counters
    numErrors = numErrors + errorStats(2);
    numBits = numBits + errorStats(3);
end

% Calculate the BER
BER = numErrors / numBits;

% Display the BER
fprintf('BER = %f\n', BER);