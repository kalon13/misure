function [errate, corrette] = processamento(modelRegions, regions, shift)
    errate = [];
    corrette = [];
	num_elementi_modello = length(modelRegions);
    num_elementi_regioni = length(regions);
    for i = 1:num_elementi_modello
        modello = modelRegions(i);
        
        accettabili_dist = [];
        
        for j = 1:num_elementi_regioni
            distance = sqrt((modello.Centroid(1) - shift(1) - regions(j).Centroid(1))^2 + ...
                            (modello.Centroid(2) - shift(2) - regions(j).Centroid(2))^2);
            if distance <= 10
                accettabili_dist = [accettabili_dist regions(j)];
            end
        end
        
        num_elementi_accettabili = length(accettabili_dist);
        
        if num_elementi_accettabili == 0
            errate = [errate; modello];
            continue;
        end
        
        accettabili_area = [];
        
        for j = 1:num_elementi_accettabili
            area_diff = sqrt((modello.Area - accettabili_dist(j).Area)^2);
            if area_diff <= 10
                accettabili_area = [accettabili_area accettabili_dist(j)];
            end
        end
        
        num_elementi_accettabili = length(accettabili_area);
        
        if num_elementi_accettabili == 0 || num_elementi_accettabili > 1
            errate = [errate; modello];
            continue;
        end
        
        corrette = [corrette; modello];
    end
end

