function K=FeatureExtraction(I)
    K = [];
    
	% CONVERT TO GRAYSCALE
    I1 = rgb2gray(I);
    
    % GAUSSIAN FILTERING
    I2 = imgaussfilt(I1,2);
    
    % BINARIZE THE IMAGE USING OTSU'S THRESHOLDING
    I3 = ~imbinarize(I2);
    
    % EROSION
    I3 = imerode(I3, strel('disk',4));
    
    % REMOVE UNWANTED REGIONS
    I3 = bwareaopen(I3, 400); % Remove components with < 400 pixels
    
    % DILATION
    I4 = imdilate(I3, strel('disk',3));
    imshow(I4)
    
    % Extract the 3 Regions (Digits)
    cc = bwconncomp(I4,4);
    props = regionprops(cc, 'Image');

    if cc.NumObjects == 1
        [h,w] = size(props(1).Image);
        split = round(w/3);
        d1 = imcrop(props(1).Image,[0 0 split h]);
        d2 = imcrop(props(1).Image,[split 0 split h]);
        d3 = imcrop(props(1).Image,[split*2 0 split h]);
        f1 = ShapeFeats(d1);
        f2 = ShapeFeats(d2);
        f3 = ShapeFeats(d3);
        K(1,:,:) = f1;K(2,:,:) = f2;K(3,:,:) = f3;
        
    elseif cc.NumObjects == 2
        [h1,w1] = size(props(1).Image);
        [h2,w2] = size(props(2).Image);
        if w1 > w2 % Split first image
            d1 = imcrop(props(1).Image,[0 0 round(w1/2) h1]);
            d2 = imcrop(props(1).Image,[round(w1/2) 0 round(w1/2) h1]);
            d3 = props(2).Image;
        else % Split second image
            d1 = props(1).Image;
            d2 = imcrop(props(2).Image,[0 0 round(w2/2) h2]);
            d3 = imcrop(props(2).Image,[round(w2/2) 0 round(w2/2) h2]);
        end
        f1 = ShapeFeats(d1);
        f2 = ShapeFeats(d2);
        f3 = ShapeFeats(d3);
        K(1,:,:) = f1;K(2,:,:) = f2;K(3,:,:) = f3;
        
    elseif cc.NumObjects == 3
        K(1,:,:) = ShapeFeats(props(1).Image);
        K(2,:,:) = ShapeFeats(props(2).Image);
        K(3,:,:) = ShapeFeats(props(3).Image);
    end
end

function F=ShapeFeats(S)
	fts={'Circularity','Area','Centroid','Orientation','Solidity'}; 
	Ft=regionprops('Table',S,fts{:});
	[~,idx]=max(Ft.Area);
	F=[Ft(idx,:).Variables];
end


