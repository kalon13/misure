function [ livelli_vuoto ] = addestra_vuoti( video, num_livelli_grigio, larghezza_fascia, start, fine )
%ADDESTRA_VUOTI Summary of this function goes here
%   Detailed explanation goes here

    livelli_vuoto = zeros(num_livelli_grigio, 1);

    for i = start:fine;
        % Acquisizione frame
        img_raw = read(video, i);
        % Conversione in scala di grigi
        img_gray = rgb2gray(img_raw);
        % Calcola dimensioni immagine
        [h, w] = size(img_gray);
        % Calcola area della fascia
        area = h * larghezza_fascia;
        % Estrai fascia dall'immagine
        fascia = img_gray(:, w-larghezza_fascia+1:w);
        % Estrai livelli di grigio
        gray_level = imhist(fascia, num_livelli_grigio);
        % Normalizzazione livelli
        norm_gray_level = gray_level / area;
        
        livelli_vuoto = livelli_vuoto + norm_gray_level;
    end

    livelli_vuoto = livelli_vuoto / (fine - start + 1);
end

