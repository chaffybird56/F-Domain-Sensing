% =========================================
% Experiment: The Truncation Method of FIR Design
% =========================================

% This script performs the following tasks:
% (a) Designs linear-phase lowpass filters using the truncation method for orders M = 20, 50, 150.
% (b) Demonstrates the Gibbs phenomenon for these filters.
% (c) Confirms that these filters have linear phase.
% (d) Shows that firls() produces identical impulse responses to the truncation method.
% (e) Creates a white Gaussian noise signal, filters it using conv() and filter(), and compares the outputs.

% ----------------------------------------
% Part (a): Design Linear-Phase Lowpass Filters Using the Truncation Method
% ----------------------------------------

% Define filter orders and corresponding lengths
M_values = [20, 50, 150];  % Filter orders
N_values = M_values + 1;   % Filter lengths

% Cutoff frequency
wc = pi / 3;  % Cutoff frequency in radians/sample

% Sampling frequency (for plotting purposes)
Fs = 2 * pi;  % Assume normalized frequency (2*pi radians/sample)

% Initialize cell arrays to store impulse responses and frequency responses
h_trunc = cell(1, length(N_values));
H_trunc = cell(1, length(N_values));

% Frequency vector for plotting
w = linspace(-pi, pi, 1024);

for idx = 1:length(N_values)
    M = M_values(idx);
    N = N_values(idx);
    n = -(M/2):(M/2);  % Symmetric indices for linear-phase FIR filter

    % Ideal impulse response (sinc function)
    hd = (wc / pi) * sinc((wc / pi) * n);

    % Store the impulse response
    h_trunc{idx} = hd;

    % Compute frequency response
    H = freqz(hd, 1, w);
    H_trunc{idx} = H;

    % Plot impulse response
    figure(1);
    subplot(length(N_values), 1, idx);
    stem(n, hd);
    title(['Impulse Response (h[n]) for M = ', num2str(M)]);
    xlabel('n');
    ylabel('h[n]');
end

% -----------------------------------------
% Part (b): Demonstrate the Gibbs Phenomenon
% -----------------------------------------

% Plot the magnitude responses to demonstrate the Gibbs phenomenon
figure(2);
for idx = 1:length(N_values)
    H = H_trunc{idx};
    subplot(length(N_values), 1, idx);
    plot(w, abs(H));
    title(['Magnitude Response |H(\omega)| for M = ', num2str(M_values(idx))]);
    xlabel('Frequency \omega (rad/sample)');
    ylabel('|H(\omega)|');
    axis([-pi pi 0 1.5]);
end

% -----------------------------------------
% Part (c): Confirm That These Filters Have Linear Phase
% -----------------------------------------

% Plot the phase responses to confirm linear phase
figure(3);
for idx = 1:length(N_values)
    H = H_trunc{idx};
    subplot(length(N_values), 1, idx);
    phase_H = unwrap(angle(H));
    plot(w, phase_H);
    title(['Phase Response \angle H(\omega) for M = ', num2str(M_values(idx))]);
    xlabel('Frequency \omega (rad/sample)');
    ylabel('\angle H(\omega)');
end

% -----------------------------------------
% Part (d): Compare with firls() Function
% -----------------------------------------

% Design filters using firls()
h_firls = cell(1, length(N_values));

for idx = 1:length(N_values)
    M = M_values(idx);
    N = N_values(idx);

    % Normalized frequencies for firls() (between 0 and 1)
    f = [0, wc / pi, wc / pi, 1];
    a = [1, 1, 0, 0];

    % Design filter using firls()
    h = firls(M, f, a);

    % Store the impulse response
    h_firls{idx} = h;

    % Compare impulse responses
    figure(4);
    subplot(length(N_values), 1, idx);
    stem(0:M, h_trunc{idx}, 'b', 'DisplayName', 'Truncation Method');
    hold on;
    stem(0:M, h, 'r--', 'DisplayName', 'firls()');
    title(['Comparison of Impulse Responses for M = ', num2str(M)]);
    xlabel('n');
    ylabel('h[n]');
    legend;
    hold off;
end

% -----------------------------------------
% Part (e): Filter White Gaussian Noise and Compare conv() and filter()
% -----------------------------------------

% Create white Gaussian noise signal of length 1000 using wgn()
rng('default');  % For reproducibility
w_g = wgn(1, 1000, 0, 'linear');

% Initialize cell arrays to store outputs
outputs_conv = cell(1, length(N_values));
outputs_filter = cell(1, length(N_values));

for idx = 1:length(N_values)
    h = h_trunc{idx};

    % Convolve using conv()
    y_conv = conv(w_g, h);

    % Filter using filter()
    y_filter = filter(h, 1, w_g);

    % Store outputs
    outputs_conv{idx} = y_conv;
    outputs_filter{idx} = y_filter;

    % Compare outputs
    figure(5);
    subplot(length(N_values), 1, idx);
    plot(y_conv, 'b', 'DisplayName', 'conv() Output');
    hold on;
    plot(y_filter, 'r--', 'DisplayName', 'filter() Output');
    title(['Output Comparison for M = ', num2str(M_values(idx))]);
    xlabel('Sample Index n');
    ylabel('Output');
    legend;
    hold off;
end

% Observations:
% The outputs from conv() and filter() are similar but not identical in length.
% - conv() produces an output length of (length(w_g) + length(h) - 1).
% - filter() produces an output length equal to length(w_g).
% The filter() function implements FIR filtering using difference equations, which inherently
% assumes initial conditions are zero and does not include the transient part beyond the input signal length.
% The conv() function computes the full convolution, including transient effects at the beginning and end.

% =========================================
% End of MATLAB Code
% =========================================

