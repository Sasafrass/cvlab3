function [fig]=Lucas_Canede(img_a_path,img_b_path,window_size_input)  
    % read in images
    img_a=imread(img_a_path);%'synth1.pgm');
    img_b=imread(img_b_path);%'synth2.pgm');
    % convert to appropiate format
    if size(size(img_a),2)>2;
        img_1 = im2double(rgb2gray(img_a));
        img_2 = im2double(rgb2gray(img_b));
    else;
        img_1 = im2double((img_a));
        img_2 = im2double((img_b));
    end
    %set window size (optional?)
    window_size = window_size_input;
    %get gradient
    [gx,gy] = imgradientxy(img_1);
    %time gradient
    gt=img_2-img_1;
    %velocity vectors
    v_1 = zeros(floor(size(img_2)/window_size));
    v_2 = zeros(floor(size(img_2)/window_size));
    counter1=1;
    % for non overlapping blocks get gradietns and solve for velocity
    % vector
    for i = 1:window_size-1:size(gx,1)-mod(size(gx,1),window_size)
       counter2=1;
       for j = 1:window_size-1:size(gx,1)-mod(size(gx,1),window_size)
          gx_block = gx(i:i+window_size-1, j:j+window_size-1);
          gy_block = gy(i:i+window_size-1, j:j+window_size-1);
          gt_block = gt(i:i+window_size-1, j:j+window_size-1);
          gx_block = gx_block(:);%flatten Ix
          gy_block = gy_block(:);%flatten Iy
          b = -gt_block(:); % flatten it
          A = [gx_block gy_block]; % get A here
          velocity = pinv(A)*b; % get velocity here via inverse of intensity gradients
          v_1(counter1,counter2)=velocity(1);
          v_2(counter1,counter2)=velocity(2);
          counter2=counter2+1;
       end
       counter1=counter1+1;
    end
    %plot image
    [m, n] = size(img_1);
    arrow_location = 1:window_size-1:m-mod(m,window_size);
    arrow_location=arrow_location+floor(window_size/2);
    figure();
    imshow(img_a);
    hold on;
    quiver(arrow_location, arrow_location, v_1,v_2, 'y');
end