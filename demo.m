image = 'person_toy/00000001.jpg';
threshold = 75000;
neighborhood_size = 5;
rotation_angle = 0;
gauss_sigma = 3;
filter_size = 5;

[H, r, c] = harris_corner_detector(image,threshold,neighborhood_size,gauss_sigma,filter_size,rotation_angle);
