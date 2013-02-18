function acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto)
    soglia = 0.05; %valore preso dal grafico
    buffer_size = 5; 
    counter_buffer = 1; %pos buffer dove salvare l'immagine
    counter_buffer_get = 5;%pos del buffer dove prelevare l'immaigne
    start = 0; %controlla che i primi frame non rappresentino cartoni in passaggio
    
    trovato = 0;
    
    canali = zeros(1, num_livelli_grigio);

    num_frame = 100;
    for i = 1:num_frame;
        % Acquisizione frame
        img_raw = read(video, i);
        %salva img sul buffer
        buffer(counter_buffer, :, :, :) = img_raw;
        % Conversione in scala di grigi
        img_gray = rgb2gray(img_raw);
        % Calcola dimensioni immagine
        [h, w] = size(img_gray);
        % Calcola area della fascia
        area = h * larghezza_fascia;
        % Estrai fascia dall'immagine
        fascia = img_gray(:, w - larghezza_fascia + 1:w);
        % Estrai livelli di grigio
        gray_level = imhist(fascia, num_livelli_grigio);
        % Normalizzazione livelli
        norm_gray_level = gray_level / area;
        % Salvataggio livelli su array nel tempo
        scarto = sum(abs(norm_gray_level - livelli_vuoto)) / num_livelli_grigio;
        canali(i) = scarto;
        
        %se è presente il cartone e non sono ancora state acquisite
        %immagini
        if (scarto > soglia && trovato == 0) && start == 1 
            %salvataggio delle immagini nel buffer
            img_buff = squeeze(buffer(counter_buffer_get, :, :, :));
            %mostra immagini
            figure, imshow(img_buff);
            trovato = 1;
        end
        %se non sta passando nulla
        if scarto <= soglia 
            trovato = 0;
            start = 1;
        end
        %incrementa contatore buffer
        if counter_buffer == buffer_size
             counter_buffer = 0;
        end
        counter_buffer = counter_buffer + 1;
        %incrementa contatore buffer acqusizione img
        if counter_buffer_get == buffer_size
             counter_buffer_get = 0;
        end
        counter_buffer_get = counter_buffer_get + 1;
    end
    % Visualizza i livelli di grigio nel tempo
    figure, plot(canali);
    
end
% Algoritmi da valutare:
% KMeans
% KDE
% PCA
% NN