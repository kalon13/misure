function main()
    num_livelli_grigio = 10;
    larghezza_fascia   = 20;    % pixel fascia del sensore
    
    video = VideoReader('img/video1.avi');
    
    livelli_vuoto = addestra_vuoti(video, num_livelli_grigio, larghezza_fascia, 40, 50);
    
    acquisizione(video, num_livelli_grigio, larghezza_fascia, livelli_vuoto);
    %acquisizione(video, num_livelli_grigio, larghezza_fascia);
    % processamento()
    % confronto()
    % output()
end