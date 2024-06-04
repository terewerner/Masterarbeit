function [predictedLabel] = predict_label_optimiert(integral_values,coeff, X_pca, y)
    
    % Normierung und Transformation des unbekannten Spektrums
    centeredUnknownSpectrum = zscore(integral_values);
    projectedUnknownSpectrum = centeredUnknownSpectrum * coeff(:, 1:3);
    
    % Identifikation ueber kNN-Algorithmus
    mdl = fitcknn(X_pca, y, 'NumNeighbors', 3);
    predictedLabel = predict(mdl, projectedUnknownSpectrum);

end