function [contorno, regioni] = estrazione(frame)
    regioni = [];
    immagine = imread(frame);
    GRAY = rgb2gray(immagine);
%     figure(1), imshow(GRAY);
    
    BW = GRAY > 40;
%     figure(2), imshow(BW);
    R = regionprops(BW,'PixelList','BoundingBox','Area','Perimeter','Orientation', 'Centroid');
    n_regions = length(R);
    if n_regions > 1
        contorno = R(1);
        for i = 2:n_regions
            if R(i).Area > contorno.Area
                contorno = R(i);
            end
        end
    else
       contorno =  R(1);
    end
    
    BW2 = GRAY > 120;
%     figure(3), imshow(BW2);
    BW_XOR = xor(BW, BW2);
%     figure(4), imshow(BW_XOR);
    reg = regionprops(BW_XOR,'PixelList','BoundingBox','Area','Perimeter','Orientation', 'Centroid');

    n_reg = length(reg);
    for i = 1:n_reg
        r = reg(i);
        if r.Area > 1
            regioni = [regioni; r];
        end
    end
end

