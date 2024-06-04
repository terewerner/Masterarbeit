function [coeff, X_pca, y, centeredX] = pca_analysis(integral_values, indexArray)
    % Definieren der Integralwerte und deren Indizes als x und y
    X = integral_values;
    y = indexArray';
    
    % Normierung der Daten
    centeredX = zscore(X, 0, 2);
     
    % Anwendung der PCA um Daten auf 3 Dimensionen zu reduzieren
    [coeff,~, ~, ~, explained] = pca(centeredX);
    X_pca = centeredX * coeff(:, 1:3);

    % Plotten der Ergebnisse
    figure;
    %colorPalette im Hex Code -> {'#2300BD', '#447CDD', '#2DC239', '#DD498B', '#E1B83D'}; 
    map = [ 0.2235294117647059  0.3137254901960784         0.38823529411764707
            0.07058823529411765  0.596078431372549  0.6784313725490196
            0.8941176470588236  0.7607843137254902  0.23921568627450981
            0.8196078431372549  0.30196078431372547  0.5137254901960784
            0.49019607843137253  0.8156862745098039  0.3803921568627451
    ];
    colormap (map);
    scatter3(X_pca(:, 1), X_pca(:, 2), X_pca(:, 3), 50, y, 'filled');
    hold on;

    % Textlabels der einzelnen Materialien
    classLabels = {'HDPE', 'LDPE', 'PET', 'PP', 'PS'};
    for label = 1:5
        idx = (y == label);
        text(mean(X_pca(idx, 1)), mean(X_pca(idx, 2)), mean(X_pca(idx, 3)), classLabels{label}, ...
            'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 1], 'EdgeColor', [1 1 1]);
    end

    % Diagrammanpassungen
    view(48, 134);
    set(gca, 'FontSize', 18);
    title('PCA zur Kunststoffidentifikation');
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    zlabel('Principal Component 3');

    hold off;

    % Visualisierung der kumulativen erklaerten Varianz
    figure;
    hold on;
    cumulativeExplained = cumsum(explained);
    set(gca, 'FontSize', 18);
    plot(cumulativeExplained, 'bo-', linewidth=2, Color= '#4A63DC');
    xlabel('Anzahl der Hauptkomponenten');
    ylabel('Kumulative erklärte Varianz (%)');
    title('Kumulative erklärte Varianz vs. Anzahl der Hauptkomponenten');
    hold off;

    % Plotten der Projektion auf die ersten beiden Hauptkomponenten
    figure;
    colormap (map);
    scatter(X_pca(:, 1), X_pca(:, 2),40,y, 'filled');
    hold on;

    % Textlabel mit dem vorhergesagten Material
    classLabels = {'HDPE', 'LDPE', 'PET', 'PP', 'PS'};
    for label = 1:5
        idx = (y == label);
        text(mean(X_pca(idx, 1)), mean(X_pca(idx, 2)), classLabels{label}, ...
            'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 1], 'EdgeColor', [0 0 0]);
    end

    % Diagrammanpassungen
    set(gca, 'FontSize', 18);
    title('PCA-Projektion der ersten beiden Hauptkomponenten');
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    
    hold off;
end