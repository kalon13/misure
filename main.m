% %% Dichiarazione variabili
% num_livelli_grigio = 10;    % Livelli di grigio
% larghezza_fascia   = 20;    % Larghezza fascia sensore (in pixel)
% 
% 
% addestramento_vuoti = 1;          % Addestramento si/no
% % livelli_vuoto = [   0.1447; 0.1406; 0.2739; 0.1475; 0.0856; 
% %                     0.0658; 0.0482; 0.0285; 0.0134; 0.0519; ];
% 
% %% Apertura video
% video = VideoReader('img/video1.avi');
% 
% %% Addestramento vuoti
% if addestramento_vuoti > 0
%     livelli_vuoto = addestra_vuoti(video, num_livelli_grigio, larghezza_fascia);
% end
% 
% %% Acquisizione
% acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto);
% 
% %db = db_misure();
% %db.getNewProduction()

[contornoModel, regioniModel] = estrazione('img/c0.png');
[contorno, regioni] = estrazione('img/c2.png');
shift = contornoModel.Centroid - contorno.Centroid;

[errate, corrette] = processamento(regioniModel, regioni, shift);

frame = imread('img/c0.png');
n_err = length(errate);
n_corrette = length(corrette);
for i = 1:n_err
    err = errate(i);
    n_pixel = length(err.PixelList);
    for j=1:n_pixel
        xp = err.PixelList(j, 1);
        yp = err.PixelList(j, 2);
        frame(yp, xp, :) = [255,0,0]; 
    end
end

for i = 1:n_corrette
    corr = corrette(i);
    n_pixel = length(corr.PixelList);
    for j=1:n_pixel
        xp = corr.PixelList(j, 1);
        yp = corr.PixelList(j, 2);
        frame(yp, xp, :) = [0,255,255]; 
    end
end

imshow(frame);