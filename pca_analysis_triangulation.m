function [coeff, X_pca, y, convHull,  X_pca_per_class, T] = pca_analysis_triangulation(integral_values, indexArray)
    % Definieren der Integralwerte und deren Indizes als x und y
    X = integral_values;
    y = indexArray';
    
    % Normierung der Daten
    centeredX = zscore(X, 0, 2);
    
    % Anwendung der PCA um Daten auf 3 Dimensionen zu reduzieren
    [coeff,~, latent, ~, explained] = pca(centeredX);
    X_pca = centeredX * coeff(:, 1:3);

    % Anzahl der Klassen
    num_classes = max(y);

    % Initialisierung von Zellenarrays für die PCA-Daten jeder Klasse
    X_pca_per_class = cell(1, num_classes);
    
    % Schleife über jede Klasse
    for class_idx = 1:num_classes
        % Extrahieren der Indizes der Datenpunkte für die aktuelle Klasse
        class_indices = find(y == class_idx);

        % Extrahieren der PCA-Daten für die aktuelle Klasse
        X_pca_per_class{class_idx} = X_pca(class_indices, :);
    end
 
    % Plotten der Ergebnisse
    figure;
    grid on;
    hold on;

    % Textlabels der einzelnen Materialien
    %classLabels = {'HDPE', 'LDPE', 'PET', 'PP', 'PS'};

    convHull = cell(1,5);
    T = cell(1,5);

    for label = 1:5
        idx = (y == label);
        %text(mean(X_pca(idx, 1)), mean(X_pca(idx, 2)), mean(X_pca(idx, 3)), classLabels{label}, ...
        %    'HorizontalAlignment', 'center', 'BackgroundColor', [1 1 1], 'EdgeColor', [1 1 1]);

        T{label} = delaunayTriangulation(X_pca_per_class{label});
        DT = delaunayTriangulation(X_pca_per_class{label});

        % Plotten der konvexe Hülle für jede Klasse
        convHull{label} = convexHull(DT);
        K = convHull{label};

        % Farbe basierend auf dem Label festlegen
        color = [ 0.2235294117647059  0.3137254901960784 0.38823529411764707
            0.07058823529411765  0.596078431372549  0.6784313725490196
            0.8941176470588236  0.7607843137254902  0.23921568627450981
            0.8196078431372549  0.30196078431372547  0.5137254901960784
            0.49019607843137253  0.8156862745098039  0.3803921568627451
        ]; 
        color = color(label, :); 

        % Plotten der konvexen Huelle für die aktuelle Klasse mit entsprechender Farbe
        trisurf(K, DT.Points(:, 1), DT.Points(:, 2), DT.Points(:, 3), ...
            'FaceColor', color, 'FaceAlpha', 0.3, 'EdgeColor', 'k');

        scatter3(X_pca(idx, 1), X_pca(idx, 2), X_pca(idx, 3), 50, color,  'filled');
    end
    
    
    % Diagrammanpassungen
    view(48, 134);
    title('PCA zur Kunststoffidentifikation');
    xlabel('Principal Component 1');
    ylabel('Principal Component 2');
    zlabel('Principal Component 3');

    hold off;
    
end