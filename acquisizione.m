function acquisizione()
    num_livelli_grigio = 10;
    larghezza_fascia = 20;

    immagini = ['i01.png'; 'i02.png'; 'i03.png'; 'i04.png'; 'i05.png';
                'i06.png'; 'i07.png'; 'i08.png'; 'i09.png'; 'i10.png';
                'i11.png'; 'i12.png'; 'i13.png'; 'i14.png'; 'i15.png';
                'i16.png'; 'i17.png'; 'i18.png'; 'i19.png';];
    num_frame = size(immagini, 1);
    
    %figure
    for i = 1:num_frame;
        %subplot(4,5,i)
        img_raw = imread(immagini(i, :));
        img_gray = rgb2gray(img_raw);
        [h, w] = size(img_gray);
        area = h * larghezza_fascia;
        fascia = img_gray(:, w-larghezza_fascia+1:w);
        gray_level = imhist(fascia, num_livelli_grigio);
        norm_gray_level = gray_level / area;
%         figure, imshow(img_thresh);
        %img_thresh = img_gray > 40;
        
        canale(i,:) = norm_gray_level(:);
%        fascia = img_thresh(:,1:200);
        
         %subplot(2,5,i)
         %plot(gray_level)
         %imshow(fascia)
    end
    figure, plot(canale);
    %legend('1','2','3','4','5','6','7','8','9','10');
    
end
% Algoritmi da valutare:
% KMeans
% KDE
% PCA
% NN