function acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto)
    soglia = 0.05;
    buffer_size = 5;
    counter_buffer = 1;
    counter_buffer_get = 5;
    start = 0;
    
    trovato = 0;
    
%     immagini = ['img/i01.png'; 'img/i02.png'; 'img/i03.png'; 'img/i04.png'; 'img/i05.png';
%                 'img/i06.png'; 'img/i07.png'; 'img/i08.png'; 'img/i09.png'; 'img/i10.png';
%                 'img/i11.png'; 'img/i12.png'; 'img/i13.png'; 'img/i14.png'; 'img/i15.png';
%                 'img/i16.png'; 'img/i17.png'; 'img/i18.png'; 'img/i19.png';];
%     num_frame = size(immagini, 1);
    canali = zeros(1, num_livelli_grigio);

    num_frame = 100;
    for i = 1:num_frame;
        % Acquisizione frame
        %img_raw = imread(immagini(i, :));
        img_raw = read(video, i);
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
        %canali(i,:) = norm_gray_level(:);
        %canali(i,:) = abs(norm_gray_level - livelli_vuoto);
        scarto = sum(abs(norm_gray_level - livelli_vuoto)) / num_livelli_grigio;
        canali(i) = scarto;
        
        if (scarto > soglia && trovato == 0) && start == 1
            img_buff = squeeze(buffer(counter_buffer_get, :, :, :));
            figure, imshow(img_buff);
            trovato = 1;
        end
        
        if scarto <= soglia && trovato == 1
            trovato = 0;
        end
        
        if scarto <= soglia && start == 0
            start = 1;
        end
        
        if counter_buffer == buffer_size
             counter_buffer = 0;
        end
        counter_buffer = counter_buffer + 1;
        
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