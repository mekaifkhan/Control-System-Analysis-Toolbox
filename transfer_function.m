function G = transfer_function(num, den)

    %% Create transfer function

    G = tf(num, den);

    %% Display

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                 TRANSFER FUNCTION\n');
    fprintf('====================================================\n');

    disp('G(s) = ');
    G

end