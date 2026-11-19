%% De 3: 2x2 MIMO-OFDM | 16-QAM | Rayleigh + AWGN | LS
clear; close all; clc;
rng(42, 'twister');

%% Cấu hình mô phỏng
nFFT = 64;
nFrames = 1000;
snrDb = (0:5:30).';
pilot = 2*randi([0, 1], nFFT, 1) - 1;

% Kiểm tra một khung không nhiễu trước khi đo BER và SER.
assert(isequal(simulateFrame(pilot, 0), [0, 0]), ...
    'Khung khong nhieu phai co BER = SER = 0.');

%% Đo BER và SER
errors = zeros(numel(snrDb), 2);

for s = 1:numel(snrDb)
    noiseVariance = 10^(-snrDb(s)/10);

    for frame = 1:nFrames
        errors(s, :) = errors(s, :) + simulateFrame(pilot, noiseVariance);
    end
end

totalSymbols = nFrames * nFFT * 2;
ber = errors(:, 1) / (4 * totalSymbols);
ser = errors(:, 2) / totalSymbols;

disp(table(snrDb, ber, ser, 'VariableNames', {'SNR_dB', 'BER', 'SER'}));

figure;
semilogy(snrDb, ber, 'b-o', snrDb, ser, 'r-s', 'LineWidth', 1.5);
grid on;
xlabel('Average SNR per receive antenna (dB)');
ylabel('Error rate');
legend('BER', 'SER', 'Location', 'southwest');
title('2x2 MIMO-OFDM | 16-QAM | Rayleigh + AWGN');

function errors = simulateFrame(pilot, noiseVariance)
    nFFT = numel(pilot);

    %% Phát 16-QAM Gray
    bits = randi([0, 1], nFFT, 2, 4);
    inPhase = (1 - 2*bits(:, :, 1)) .* (3 - 2*bits(:, :, 2));
    quadrature = (1 - 2*bits(:, :, 3)) .* (3 - 2*bits(:, :, 4));

    % Công suất chòm sao là 10. Chia đều công suất cho hai anten.
    qamScale = sqrt(20);
    data = (inPhase + 1i*quadrature) / qamScale;

    % Mỗi ma trận có ba cột ứng với ba khe OFDM.
    silent = zeros(nFFT, 1);
    tx1 = [pilot, silent, data(:, 1)];
    tx2 = [silent, pilot, data(:, 2)];
    txGrid = cat(3, tx1, tx2);

    % IFFT rồi chép mẫu cuối lên đầu để tạo CP dài một mẫu.
    txTime = sqrt(nFFT) * ifft(txGrid, [], 1);
    txTime = [txTime(end, :, :); txTime];

    %% Kênh Rayleigh hai đường và nhiễu AWGN
    % h có thứ tự [đường truyền, anten thu, anten phát].
    h = (randn(2, 2, 2) + 1i*randn(2, 2, 2)) / 2;
    rxTime = zeros(size(txTime));

    for rx = 1:2
        fromTx1 = filter(h(:, rx, 1), 1, txTime(:, :, 1));
        fromTx2 = filter(h(:, rx, 2), 1, txTime(:, :, 2));
        rxTime(:, :, rx) = fromTx1 + fromTx2;
    end

    noise = randn(size(rxTime)) + 1i*randn(size(rxTime));
    rxTime = rxTime + sqrt(noiseVariance/2) * noise;

    %% Bỏ CP, chạy FFT và cân bằng bằng LS
    rxGrid = fft(rxTime(2:end, :, :), [], 1) / sqrt(nFFT);
    detected = zeros(nFFT, 2);

    for k = 1:nFFT
        % Hàng ứng với anten thu, cột ứng với anten phát.
        pilotRx = [rxGrid(k, 1, 1), rxGrid(k, 2, 1);
                   rxGrid(k, 1, 2), rxGrid(k, 2, 2)];

        Hls = pilotRx / pilot(k);
        dataRx = [rxGrid(k, 3, 1); rxGrid(k, 3, 2)];
        detected(k, :) = (qamScale * (Hls \ dataRx)).';
    end

    %% Giải điều chế và đếm lỗi
    inPhase = real(detected);
    quadrature = imag(detected);
    receivedBits = cat(3, inPhase < 0, abs(inPhase) < 2, ...
                         quadrature < 0, abs(quadrature) < 2);

    wrongBits = receivedBits ~= bits;
    errors = [nnz(wrongBits), nnz(any(wrongBits, 3))];
end
