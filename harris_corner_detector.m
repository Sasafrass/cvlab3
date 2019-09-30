function [H, r, c] = harris_corner_detector(image,threshold,neighborhood_size,gauss_sigma,filter_size,rotation_angle)
    close all
    n = uint8(neighborhood_size); %used for checking if pixel has largest H value in a n by n neighborhood
%     I = image;
    rot_I = imrotate(imread(image),rotation_angle);
    I = rgb2gray(rot_I);
    
    gaussian = fspecial('gaussian',filter_size,gauss_sigma);
    xDer = fspecial('sobel');
    yDer = xDer';
    
    Gx = imfilter(gaussian,xDer,'conv');
    Gy = imfilter(gaussian,yDer,'conv');
    
    Ix = imfilter(double(I),Gx,'replicate','conv');
    Iy = imfilter(double(I),Gy,'replicate','conv');
    
    A = imfilter(Ix .^ 2,gaussian,'replicate','conv');
    C = imfilter(Iy .^ 2,gaussian,'replicate','conv');
    B = imfilter(Ix .* Iy,gaussian,'replicate','conv');
    
    H = (A.*C-B.^2)-0.04*(A+C).^2;
    
    winners = H .* (H > threshold); %sets all values below the threshold to 0
    i = size(winners);
    corners = zeros(i);
    
    padsize = double(floor((double(n)/2)));
    winners = padarray(winners,[padsize,padsize]);
    
    %Loop over all pixels to see if they are the maximum in their n by n
    %neighborhood
    for x = padsize+1:uint16(i(1))
        for y = padsize+1:uint16(i(2))
%             sum(H(x-padsize:x+padsize,y-padsize:y+padsize) < winners(x,y))
            maxV = max(max(winners(x-padsize:x+padsize,y-padsize:y+padsize)));
            if ( winners(x,y) == maxV)
                 corners(x-padsize,y-padsize) = maxV;
            end
        end
    end
    [r,c] = find(corners);
    
    a = sum(abs(Gx),'all')*255;
    b = a/2;
    figure, imshow((Ix+b)./a)
    figure, imshow((Iy+b)./a)
    
    figure, imshow(rot_I)
    hold on;
    plot(c,r, 'bo', 'MarkerSize', 5, 'LineWidth', 1);
end

