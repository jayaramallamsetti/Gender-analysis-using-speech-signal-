function GenderAnalysisGUI()
    % Create the figure window
    fig = figure('Name', 'Gender Analysis using Speech Signal', 'Position', [300, 300, 800, 500]);


    uicontrol('Style', 'text', 'String', 'Select Audio File:', 'Position', [50, 450, 100, 20]);
    audioFileEditBox = uicontrol('Style', 'edit', 'String', '', 'Position', [150, 450, 300, 20]);
    audioFileButton = uicontrol('Style', 'pushbutton', 'String', 'Browse', 'Position', [460, 450, 80, 20], 'Callback', @browseAudioFile);

    uicontrol('Style', 'text', 'String', 'Fundamental Frequency:', 'Position', [50, 400, 150, 20]);
    fundamentalFreqText = uicontrol('Style', 'text', 'String', '', 'Position', [200, 400, 100, 20]);

    uicontrol('Style', 'text', 'String', 'Zero Crossing Rate:', 'Position', [50, 350, 150, 20]);
    zeroCrossingText = uicontrol('Style', 'text', 'String', '', 'Position', [200, 350, 100, 20]);

    uicontrol('Style', 'text', 'String', 'Short Energy:', 'Position', [50, 300, 150, 20]);
    shortEnergyText = uicontrol('Style', 'text', 'String', '', 'Position', [200, 300, 100, 20]);

    uicontrol('Style', 'text', 'String', 'Gender:', 'Position', [50, 250, 150, 20]);
    genderText = uicontrol('Style', 'text', 'String', '', 'Position', [200, 250, 100, 20]);

    analyzeButton = uicontrol('Style', 'pushbutton', 'String', 'Analyze', 'Position', [250, 200, 100, 30], 'Callback', @analyzeAudio);

    playButton = uicontrol('Style', 'pushbutton', 'String', 'Play Audio', 'Position', [250, 150, 100, 30], 'Callback', @playAudio);

    
    audioAxes = axes('Position', [500, 150, 300, 300]);

    % Function to handle the "Browse" button click
    function browseAudioFile(~, ~)
        [fileName, filePath] = uigetfile('*.wav', 'Select Audio File');
        if fileName ~= 0
            set(audioFileEditBox, 'String', [filePath, fileName]);
        end
    end

    % Function to handle the "Analyze" button click
    function analyzeAudio(~, ~)
        audioFile = get(audioFileEditBox, 'String');
        if ~isempty(audioFile)
            [my2, fs] = audioread(audioFile);
            [fundamental, zcr_avg, sum_short_avg] = Charac_features(my2, fs);
            set(fundamentalFreqText, 'String', num2str(fundamental));
            set(zeroCrossingText, 'String', num2str(zcr_avg));
            set(shortEnergyText, 'String', num2str(sum_short_avg));

            fundamental_freq_level = 135;
            zero_crossing_level = 12;
            short_energy_level = 0.5;

            marks = 0.25 * (fundamental / fundamental_freq_level) + (zcr_avg / zero_crossing_level) * 0.35;
            marks = marks + (0.4 * sum_short_avg / short_energy_level);

            if marks > 1
                set(genderText, 'String', 'Female');
            else
                set(genderText, 'String', 'Male');
            end

            % Plot the audio signal
            cla(audioAxes);
            plot(audioAxes, my2);
            xlabel(audioAxes, 'Index');
            ylabel(audioAxes, 'Amplitude');
            title(audioAxes, 'Audio Signal');
        else
            set(genderText, 'String', 'Please select an audio file.');
        end
    end

    % Function to handle the "Play Audio" button click
    function playAudio(~, ~)
        audioFile = get(audioFileEditBox, 'String');
        if ~isempty(audioFile)
            [my2, fs] = audioread(audioFile);
            sound(my2, fs);
        else
            set(genderText, 'String', 'Please select an audio file.');
        end
    end
end