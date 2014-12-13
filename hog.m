img = im2double(imread('hog_girl.jpeg'));

    [featureVector, hogVisualization] = extractHOGFeatures(img);

    figure;
    imshow(img); hold on;
    plot(hogVisualization);
