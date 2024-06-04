function [predictedLabel] = predict_label_optimiert_triangulation_hauptkomp(integral_values,coeff,X_pca_per_class, tolHDPE, tolLDPE,tolPET, tolPP, tolPS, hauptKomp)

    % Normierung und Transformation des unbekannten Spektrums
    centeredUnknownSpectrum = zscore(integral_values);
    unknown_point = centeredUnknownSpectrum * coeff(:, 1:hauptKomp);

    % Ueberpruefung ob und wenn ja in welcher Huellkurve die Testdaten liegen
    predictedLabel = 0;
    for i = 1:5
        AT = X_pca_per_class{i};
        tol = [tolHDPE, tolLDPE, tolPET, tolPP, tolPS];
        in = inhull(unknown_point, AT, [], tol(i));       
        if in == 1
            predictedLabel = i;
            break; % Beende die Schleife, wenn in gleich 1 ist
        end
    end   
end