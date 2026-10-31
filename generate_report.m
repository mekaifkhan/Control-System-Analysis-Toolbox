
function report_file = generate_report(G, num, den, p, z, info, ...
    R, sign_changes, routh_stable, GM_dB, PM, Wcg, Wcp)

% GENERATE_REPORT
% Professional HTML report generator for Control System Analysis Toolbox
% Developed by Kaif Ahmad Khan
% Electronics and Communication Engineering
% Jamia Millia Islamia

clc;

%% 1. CREATE REPORT DIRECTORIES

src_folder = fileparts(mfilename('fullpath'));
project_folder = fileparts(src_folder);

report_folder = fullfile(project_folder, 'Analysis_Report');
assets_folder = fullfile(report_folder, 'report_assets');

if ~exist(report_folder, 'dir')
    mkdir(report_folder);
end

if ~exist(assets_folder, 'dir')
    mkdir(assets_folder);
end

report_file = fullfile(report_folder, ...
    'Control_System_Analysis_Report.html');

%% 2. EXTRACT TRANSFER FUNCTION

[num_tf, den_tf] = tfdata(G, 'v');

num_text = strtrim(poly2str(num_tf, 's'));
den_text = strtrim(poly2str(den_tf, 's'));


%% 3. EXPORT MATLAB FIGURES

% Find currently valid MATLAB figure windows
figures = findall(0, 'Type', 'figure');

% Preferred order of analysis plots
preferred_names = {
    'Nyquist Plot'
    'Bode Plot'
    'Root Locus'
    'Impulse Response'
    'Step Response'
    'Pole-Zero Map'
};

plot_titles = {};
plot_files = {};

for k = 1:length(preferred_names)

    for j = 1:length(figures)

        % Skip invalid or deleted figure handles
        if ~isgraphics(figures(j), 'figure')
            continue;
        end

        try
            fig_name = get(figures(j), 'Name');
        catch
            continue;
        end

        if strcmpi(strtrim(fig_name), preferred_names{k})

            image_name = sprintf('plot_%02d.png', k);
            image_path = fullfile(assets_folder, image_name);

            try
                exportgraphics(figures(j), image_path, ...
                    'Resolution', 300);

            catch
                try
                    saveas(figures(j), image_path);
                catch
                    warning('Could not export figure: %s', fig_name);
                    continue;
                end
            end

            % Add only successfully exported images
            if exist(image_path, 'file')

                plot_titles{end+1} = preferred_names{k};
                plot_files{end+1} = ['report_assets/' image_name];

            end

            break;

        end

    end

end

%% 4. OPEN HTML REPORT

fid = fopen(report_file, 'w');

if fid == -1
    error('Unable to create the HTML report file.');
end

file_cleanup = onCleanup(@() fclose(fid));

%% 5. HTML HEADER AND PROFESSIONAL CSS

fprintf(fid, '<!DOCTYPE html>\n');
fprintf(fid, '<html lang="en">\n<head>\n');
fprintf(fid, '<meta charset="UTF-8">\n');
fprintf(fid, '<meta name="viewport" content="width=device-width, initial-scale=1.0">\n');
fprintf(fid, '<title>Control System Analysis Report</title>\n');

fprintf(fid, '<style>\n');

fprintf(fid, 'body {');
fprintf(fid, 'font-family: Arial, Helvetica, sans-serif;');
fprintf(fid, 'color: #263238;');
fprintf(fid, 'margin: 35px auto;');
fprintf(fid, 'max-width: 950px;');
fprintf(fid, 'padding: 25px;');
fprintf(fid, 'line-height: 1.55;');
fprintf(fid, '}\n');

fprintf(fid, 'h1 {color:#17365D;text-align:center;font-size:30px;}\n');
fprintf(fid, 'h2 {color:#17365D;border-bottom:2px solid #d8e1ed;padding-bottom:7px;margin-top:30px;}\n');
fprintf(fid, 'h3 {color:#263238;margin-bottom:12px;}\n');

fprintf(fid, 'table {width:100%%;border-collapse:collapse;margin:15px 0 22px 0;}\n');

fprintf(fid, 'th,td {border:1px solid #bfc7ce;padding:10px;text-align:left;}\n');

fprintf(fid, 'th {background:#eaf0f6;color:#17365D;}\n');

fprintf(fid, 'tr {page-break-inside:avoid;break-inside:avoid;}\n');

fprintf(fid, '.cover {text-align:center;margin-top:65px;margin-bottom:75px;}\n');

fprintf(fid, '.subtitle {font-size:19px;font-weight:bold;}\n');

fprintf(fid, '.meta {color:#555;margin:8px;}\n');

fprintf(fid, '.transfer {');
fprintf(fid, 'text-align:center;');
fprintf(fid, 'padding:20px;');
fprintf(fid, 'margin:15px 0 25px 0;');
fprintf(fid, 'background:#f1f5f9;');
fprintf(fid, 'border-radius:6px;');
fprintf(fid, 'font-size:20px;');
fprintf(fid, 'font-weight:bold;');
fprintf(fid, '}\n');

fprintf(fid, '.status {color:#176b45;font-weight:bold;}\n');

fprintf(fid, '.plot-section {');
fprintf(fid, 'margin:25px 0 35px 0;');
fprintf(fid, 'page-break-inside:avoid;');
fprintf(fid, 'break-inside:avoid;');
fprintf(fid, '}\n');

fprintf(fid, '.plot-section h3 {page-break-after:avoid;break-after:avoid;}\n');

fprintf(fid, '.plot-section img {');
fprintf(fid, 'width:100%%;');
fprintf(fid, 'height:auto;');
fprintf(fid, 'max-height:6.2in;');
fprintf(fid, 'object-fit:contain;');
fprintf(fid, 'display:block;');
fprintf(fid, 'margin:0 auto;');
fprintf(fid, 'border:1px solid #e0e0e0;');
fprintf(fid, '}\n');

fprintf(fid, '.footer {');
fprintf(fid, 'margin-top:50px;');
fprintf(fid, 'padding-top:15px;');
fprintf(fid, 'border-top:2px solid #aaa;');
fprintf(fid, 'color:#666;');
fprintf(fid, '}\n');

fprintf(fid, '@media print {');
fprintf(fid, 'body {max-width:none;margin:10mm;padding:0;}');
fprintf(fid, '.plot-section {page-break-inside:avoid;break-inside:avoid;}');
fprintf(fid, 'h2 {page-break-after:avoid;break-after:avoid;}');
fprintf(fid, '}\n');

fprintf(fid, '</style>\n</head>\n<body>\n');

%% 6. COVER PAGE

fprintf(fid, '<div class="cover">\n');

fprintf(fid, '<h1>CONTROL SYSTEM ANALYSIS REPORT</h1>');

fprintf(fid, '<p class="subtitle">Control System Analysis &amp; Stability Toolbox</p>');

fprintf(fid, '<p>Developed by <b>Kaif Ahmad Khan</b></p>');

fprintf(fid, '<p class="meta">Electronics and Communication Engineering</p>');

fprintf(fid, '<p class="meta">Jamia Millia Islamia</p>');

fprintf(fid, '<p class="meta">Generated: %s</p>', ...
    datestr(now, 'dd-mmm-yyyy HH:MM:SS'));

fprintf(fid, '</div>\n');

%% 7. SYSTEM INFORMATION

fprintf(fid, '<h2>1. System Information</h2>');

fprintf(fid, '<table>');

fprintf(fid, '<tr><th>Parameter</th><th>Value</th></tr>');

fprintf(fid, '<tr><td>System Type</td><td>Continuous-time LTI</td></tr>');

fprintf(fid, '<tr><td>System Order</td><td>%d</td></tr>', ...
    length(den)-1);

fprintf(fid, '<tr><td>Numerator</td><td>%s</td></tr>', ...
    mat2str(num));

fprintf(fid, '<tr><td>Denominator</td><td>%s</td></tr>', ...
    mat2str(den));

fprintf(fid, '</table>');

fprintf(fid, '<h3>Transfer Function</h3>');

fprintf(fid, '<div class="transfer">');

fprintf(fid, 'G(s) = (%s) / (%s)', num_text, den_text);

fprintf(fid, '</div>');

%% 8. POLE-ZERO ANALYSIS

fprintf(fid, '<h2>2. Pole-Zero Analysis</h2>');

fprintf(fid, '<table>');

fprintf(fid, '<tr><th>Parameter</th><th>Result</th></tr>');

fprintf(fid, '<tr><td>Poles</td><td>%s</td></tr>', ...
    mat2str(p, 5));

if isempty(z)
    zero_text = 'No finite zeros';
else
    zero_text = mat2str(z, 5);
end

fprintf(fid, '<tr><td>Zeros</td><td>%s</td></tr>', ...
    zero_text);

if all(real(p) < 0)
    pole_status = 'STABLE';
elseif any(real(p) > 0)
    pole_status = 'UNSTABLE';
else
    pole_status = 'CHECK IMAGINARY-AXIS POLES';
end

fprintf(fid, '<tr><td>Pole Stability</td><td>%s</td></tr>', ...
    pole_status);

fprintf(fid, '</table>');

%% 9. ROUTH-HURWITZ ANALYSIS

fprintf(fid, '<h2>3. Routh-Hurwitz Stability Analysis</h2>');

if routh_stable
    routh_text = 'STABLE';
else
    routh_text = 'UNSTABLE';
end

fprintf(fid, '<p>Routh Stability: <b>%s</b></p>', ...
    routh_text);

fprintf(fid, '<p>First-column sign changes: %d</p>', ...
    sign_changes);

fprintf(fid, '<table>');

fprintf(fid, '<tr>');

for col = 1:size(R, 2)
    fprintf(fid, '<th>Column %d</th>', col);
end

fprintf(fid, '</tr>');

for i = 1:size(R, 1)

    fprintf(fid, '<tr>');

    for j = 1:size(R, 2)

        fprintf(fid, '<td>%s</td>', ...
            report_number(R(i,j)));

    end

    fprintf(fid, '</tr>');

end

fprintf(fid, '</table>');

%% 10. TIME-DOMAIN PERFORMANCE

fprintf(fid, '<h2>4. Time-Domain Performance</h2>');

fprintf(fid, '<table>');

fprintf(fid, '<tr><th>Parameter</th><th>Value</th></tr>');

time_fields = {
    'RiseTime', 'Rise Time', ' s'
    'SettlingTime', 'Settling Time', ' s'
    'PeakTime', 'Peak Time', ' s'
    'Peak', 'Peak Value', ''
    'Overshoot', 'Overshoot', ' %'
};

for k = 1:size(time_fields, 1)

    field_name = time_fields{k, 1};
    display_name = time_fields{k, 2};
    unit = time_fields{k, 3};

    if isfield(info, field_name)

        value = info.(field_name);

        fprintf(fid, '<tr><td>%s</td><td>%s%s</td></tr>', ...
            display_name, report_number(value), unit);

    end
end

if isfield(info, 'FinalValue')

    fprintf(fid, '<tr><td>Final Value</td><td>%s</td></tr>', ...
        report_number(info.FinalValue));

end

fprintf(fid, '</table>');

%% 11. FREQUENCY-DOMAIN PERFORMANCE

fprintf(fid, '<h2>5. Frequency-Domain Performance</h2>');

fprintf(fid, '<table>');

fprintf(fid, '<tr><th>Parameter</th><th>Value</th></tr>');

fprintf(fid, '<tr><td>Gain Margin</td><td>%s dB</td></tr>', ...
    report_number(GM_dB));

fprintf(fid, '<tr><td>Phase Margin</td><td>%s degrees</td></tr>', ...
    report_number(PM));

fprintf(fid, '<tr><td>Gain Crossover Frequency</td><td>%s</td></tr>', ...
    report_frequency(Wcg));

fprintf(fid, '<tr><td>Phase Crossover Frequency</td><td>%s</td></tr>', ...
    report_frequency(Wcp));

fprintf(fid, '</table>');

%% 12. ENGINEERING ASSESSMENT

fprintf(fid, '<h2>6. Engineering Assessment</h2>');

fprintf(fid, '<p>Pole-based stability: <b>%s</b></p>', ...
    pole_status);

fprintf(fid, '<p>Routh-Hurwitz result: <b>%s</b></p>', ...
    routh_text);

% Overall stability assessment is based on pole and Routh results.
% This is an analytical indicator, not a complete design validation.

if strcmp(pole_status, 'STABLE') && routh_stable

    overall_status = 'STABLE';

else

    overall_status = 'REQUIRES FURTHER ANALYSIS';

end

fprintf(fid, '<p class="status">Overall Assessment: %s</p>', ...
    overall_status);

fprintf(fid, ['<p>These results summarize the mathematical stability ' ...
    'and performance indicators calculated by the toolbox. ' ...
    'Design suitability should be assessed against application ' ...
    'requirements and engineering specifications.</p>']);

%% 13. ANALYSIS PLOTS

fprintf(fid, '<h2>7. Analysis Plots</h2>');

if isempty(plot_titles)

    fprintf(fid, '<p>No analysis plots were found.</p>');

else

    for k = 1:length(plot_titles)

        fprintf(fid, '<div class="plot-section">');

        fprintf(fid, '<h3>%s</h3>', plot_titles{k});

        fprintf(fid, '<img src="%s" alt="%s">', ...
            plot_files{k}, plot_titles{k});

        fprintf(fid, '</div>');

    end

end

%% 14. FOOTER

fprintf(fid, '<div class="footer">');

fprintf(fid, '<p>Generated automatically by Control System Analysis Toolbox.</p>');

fprintf(fid, '<p>Developed by Kaif Ahmad Khan | Jamia Millia Islamia</p>');

fprintf(fid, '</div>');

fprintf(fid, '</body>\n</html>');

clear file_cleanup;

fprintf('\nProfessional analysis report generated successfully.\n');

fprintf('Report location: %s\n', report_file);

end

%% ============================================================
% HELPER FUNCTION 1: NUMERICAL FORMATTING
% =============================================================

function output = report_number(value)

if isempty(value)

    output = 'Not available';

elseif isscalar(value) && isinf(value)

    output = 'Infinite';

elseif isscalar(value) && isnan(value)

    output = 'Not available';

elseif isscalar(value)

    output = sprintf('%.5g', value);

else

    output = mat2str(value, 5);

end

end

%% ============================================================
% HELPER FUNCTION 2: FREQUENCY FORMATTING
% =============================================================

function output = report_frequency(value)

if isempty(value) || isnan(value)

    output = 'Not available';

elseif isinf(value)

    output = 'No finite crossover';

else

    output = sprintf('%.5g rad/s', value);

end

end
