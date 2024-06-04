function [specMatrix, firstWordsList, wavelengths_NIR] = NIR_vorbereiten( path)
    
    % Ordner auswählen
    selectedFolder = path;
    
    % Alle CSV-Dateien im ausgewaehlten Ordner laden
    files = dir(fullfile(selectedFolder, '*.csv'));
    numFiles = length(files);
    
    % Initialisierung der Spektrummatrix und Materialmatrix
    specMatrix = [];
    firstWordsList = {};
    
    firstFile = fullfile(selectedFolder, files(1).name);
    waveData = readmatrix(firstFile, 'Delimiter', ';');
    wavelengths_NIR = waveData(:, 1);

    % Durchlaufen aller gefundenen CSV-Dateien
    for i = 1:numFiles
        % Daten aus aktueller CSV-Datei laden
        currentFile = fullfile(selectedFolder, files(i).name);
        currentData = readmatrix(currentFile, 'Delimiter', ';');
        
        % Materialname (vor dem ersten Unterstrich) extrahieren
        [~, fileName, ~] = fileparts(files(i).name);
        firstWord = strtok(fileName, '_');
        
        % Zu firstWordsList hinzufuegen
        firstWordsList = [firstWordsList, {firstWord}];
       
        % Reflektanzwerte zu specMatrix hinzufuegen
        reflectance_NIR = currentData(:,2);
        specMatrix = [specMatrix, reflectance_NIR];
    end
end