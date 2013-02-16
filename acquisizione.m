function acquisizione()
    % Parametri di acquisizione
    num_livelli_grigio = 10;
    larghezza_fascia   = 20;    % pixel fascia del sensore

    immagini = ['i01.png'; 'i02.png'; 'i03.png'; 'i04.png'; 'i05.png';
                'i06.png'; 'i07.png'; 'i08.png'; 'i09.png'; 'i10.png';
                'i11.png'; 'i12.png'; 'i13.png'; 'i14.png'; 'i15.png';
                'i16.png'; 'i17.png'; 'i18.png'; 'i19.png';];
    num_frame = size(immagini, 1);
    
    for i = 1:num_frame;
        % Acquisizione frame
        img_raw = imread(immagini(i, :));
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
        % Salvataggio livelli su array nel tempo
        canali(i,:) = norm_gray_level(:);
    end
    % Visualizza i livelli di grigio nel tempo
    figure, plot(canali);
    
end
% Algoritmi da valutare:
% KMeans
% KDE
% PCA
% NN