function info = time_response(G)

    %% Calculate time response characteristics

    info = stepinfo(G);
    info.SystemOrder = order(G);
info.FinalValue = dcgain(G);

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                TIME-DOMAIN ANALYSIS\n');
    fprintf('====================================================\n');

    fprintf('\nRise Time       : %.4f s\n', info.RiseTime);
    fprintf('Settling Time   : %.4f s\n', info.SettlingTime);
    fprintf('Peak Time       : %.4f s\n', info.PeakTime);
    fprintf('Maximum Peak    : %.4f\n', info.Peak);
    fprintf('Overshoot       : %.2f %%\n', info.Overshoot);

    %% Step Response

    figure('Name','Step Response');

    step(G);

    grid on;
    title('Step Response');
    xlabel('Time (s)');
    ylabel('Amplitude');

    %% Impulse Response

    figure('Name','Impulse Response');

    impulse(G);

    grid on;
    title('Impulse Response');
    xlabel('Time (s)');
    ylabel('Amplitude');

end