%% Dichiarazione variabili
num_livelli_grigio = 10;    % Livelli di grigio
larghezza_fascia   = 20;    % Larghezza fascia sensore (in pixel)


addestramento_vuoti = 1;          % Addestramento si/no
% livelli_vuoto = [   0.1447; 0.1406; 0.2739; 0.1475; 0.0856; 
%                     0.0658; 0.0482; 0.0285; 0.0134; 0.0519; ];

%% Apertura video
video = VideoReader('img/video1.avi');

%% Addestramento vuoti
if addestramento_vuoti > 0
    livelli_vuoto = addestra_vuoti(video, num_livelli_grigio, larghezza_fascia);
end

%% Acquisizione
acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto);