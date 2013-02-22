function [ livelli_vuoto ] = addestra_vuoti(video, num_livelli_grigio, larghezza_fascia)
    %% Inizializzazione parametri  
    start = 40;     % Frame iniziale
    fine = 50;      % Frame finale
    
    w = 1024;
    h = 768;
    area = h * larghezza_fascia;
    
    somma_livelli_vuoto = zeros(num_livelli_grigio, 1);

    %% Acquisizione
    for i = start:fine;
        % Acquisizione frame
        img_raw = read(video, i);
        % Conversione in scala di grigi
        img_gray = rgb2gray(img_raw);
        % Estrai fascia dall'immagine
        fascia = img_gray(:, w-larghezza_fascia+1:w);
        % Estrai livelli di grigio
        gray_level = imhist(fascia, num_livelli_grigio);
        % Normalizzazione livelli
        norm_gray_level = gray_level / area;
        % Somma dei livelli con il valore precedente
        somma_livelli_vuoto = somma_livelli_vuoto + norm_gray_level;
    end
    
    %% Calcolo e plottaggio livelli
    livelli_vuoto = somma_livelli_vuoto / (fine - start + 1);
    figure('Name','Livelli non presenza cartone'), bar(livelli_vuoto);
    title('Livelli non presenza cartone');
    xlabel('Livelli');
    ylabel('Valore medio')
end

