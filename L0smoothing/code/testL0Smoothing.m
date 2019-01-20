Im = imread('IMG_20180224_092044.jpg');
S = L0Smoothing(Im,0.1);
figure, imshow(S);
