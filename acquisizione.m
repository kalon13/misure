function acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto)
    %% Inizializzazione parametri
    soglia = 0.25;          % Valore preso dal grafico
    buffer_size = 5;        % Grandezza del buffer di immagini
    counter_buffer = 1;     % Posizione buffer dove salvare l'immagine
    counter_buffer_get = 5; % Posizione del buffer dove prelevare l'immagine
    start = 0;              % Controlla che i primi frame non rappresentino cartoni in passaggio
    trovato = 0;
    
    w = 1024;
    h = 768;
    area = h * larghezza_fascia;
    
    %buffer = zeros(buffer_size, h, w, 3);
    scarti = zeros(1, num_livelli_grigio);
    
    %% Ciclo di acquisizione
    num_frame = 100;
    for i = 1:num_frame;
        % Acquisizione frame
        img_raw = read(video, i);
        % Salva img sul buffer
        buffer(counter_buffer, :, :, :) = img_raw;
        % Conversione in scala di grigi
        img_gray = rgb2gray(img_raw);        
        % Estrai fascia dall'immagine
        fascia = img_gray(:, w-larghezza_fascia+1:w);
        % Estrai livelli di grigio
        gray_level = imhist(fascia, num_livelli_grigio);
        % Normalizzazione livelli
        norm_gray_level = gray_level / area;
        % Salvataggio livelli su array nel tempo
        livelli(i, :) = norm_gray_level(:);
        %scarto = sum(abs(norm_gray_level - livelli_vuoto)) / num_livelli_grigio;
        scarto_mq = sqrt(sum((norm_gray_level - livelli_vuoto).^2));
        scarti(i) = scarto_mq;
        
        % Se è presente il cartone e non sono ancora state acquisite immagini
        if (scarto_mq > soglia && trovato == 0) && start == 1 
            % Estrazione delle immagini nel buffer
            trovato = 1;
            img_cartone = squeeze(buffer(counter_buffer_get, :, :, :));
            % Mostra immagini
            figure('Name', ['Frame ' int2str(i)]), imshow(img_cartone);
            %% processamento()
            %% confronto()
            %% output()
        end
        
        % Se non sta passando nulla azzero le variabili
        if scarto_mq <= soglia 
            trovato = 0;
            start = 1;
        end
        
        %% Incrementa contatori
        % Incrementa contatore buffer
        if counter_buffer == buffer_size
             counter_buffer = 0;
        end
        counter_buffer = counter_buffer + 1;
        
        % Incrementa contatore buffer acqusizione img
        if counter_buffer_get == buffer_size
             counter_buffer_get = 0;
        end
        counter_buffer_get = counter_buffer_get + 1;
    end
    
    %% Plottaggio livelli
    figure('Name', 'Livelli di grigio'), plot(livelli);
    title('Andamento livelli di grigio');
    xlabel('Frame');
    ylabel('Valore')
    figure('Name', 'Scarto'), plot(scarti);
    title('Andamento scarto medio quadratico');
    xlabel('Frame');
    ylabel('Valore')
end