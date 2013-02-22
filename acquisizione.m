function acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto)
    %% Dichiarazione variabili
    soglia = 0.05;          % Valore preso dal grafico
    buffer_size = 5; 
    counter_buffer = 1;     % pos buffer dove salvare l'immagine
    counter_buffer_get = 5; % pos del buffer dove prelevare l'immaigne
    start = 0;              % controlla che i primi frame non rappresentino cartoni in passaggio
    
    w = 1024; h = 768;              % Dimensioni video
    area = h * larghezza_fascia;	% Calcola area della fascia
    
    %% Inizializzazione buffer e variabili
    trovato = 0;
    %buffer = zeros(buffer_size, h, w, 3);
    canali = zeros(1, num_livelli_grigio);

    num_frame = 100;
    for i = 1:num_frame;
        % Acquisizione frame
        img_raw = read(video, i);
        %salva img sul buffer
        buffer(counter_buffer, :, :, :) = img_raw;
        % Conversione in scala di grigi
        img_gray = rgb2gray(img_raw);        
        % Estrai fascia dall'immagine
        fascia = img_gray(:, w - larghezza_fascia + 1:w);
        % Estrai livelli di grigio
        gray_level = imhist(fascia, num_livelli_grigio);
        % Normalizzazione livelli
        norm_gray_level = gray_level / area;
        % Salvataggio livelli su array nel tempo
        livelli(i, :) = norm_gray_level(:);
        scarto = sum(abs(norm_gray_level - livelli_vuoto)) / num_livelli_grigio;
        canali(i) = scarto;
        
        % Se è presente il cartone e non sono ancora state acquisite immagini
        if (scarto > soglia && trovato == 0) && start == 1 
            % Estrazione delle immagini nel buffer
            trovato = 1;
            img_buff = squeeze(buffer(counter_buffer_get, :, :, :));
            % Mostra immagini
            figure, imshow(img_buff);
            %% processamento()
            %% confronto()
            %% output()
        end
        
        %se non sta passando nulla
        if scarto <= soglia 
            trovato = 0;
            start = 1;
        end
        %% Incrementa contatori
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
    figure, plot(livelli);
    figure, plot(canali);
    
end
% Algoritmi da valutare:
% KMeans
% KDE
% PCA
% NN