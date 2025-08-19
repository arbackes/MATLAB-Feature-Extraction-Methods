% [hematoxilina, eosina, dab] = deconvolucaoCor(rgb)
% Calcula a deconvolução de cor de imagens RGB tingidas com Hematoxilina e
% Eosina (H & E)
% 
% Paper: RUIFROK, A. C.; JOHNSTON, D. A. Quantification of histochemical 
% staining by color deconvolution. Analytical and quantitative cytology 
% and histology, v. 23, n. 4, p. 291–299, 2001.

function imageHDAB = deconvolucaoCor(imageRGB)
    % alternative set of standard values (HDAB from Fiji)
%     He = [ 0.6500286;  0.704031;    0.2860126 ];
%     DAB = [ 0.26814753;  0.57031375;  0.77642715];
%     Res = [ 0.7110272;   0.42318153; 0.5615672 ]; % residual

    % combine stain vectors to deconvolution matrix
%     HDABtoRGB = [He/norm(He) DAB/norm(DAB) Res/norm(Res)]';

    % set of standard values for stain vectors (from python scikit)
    He = [0.65; 0.70; 0.29];
    Eo = [0.07; 0.99; 0.11];
    DAB = [0.27; 0.57; 0.78];    
    HDABtoRGB = [He Eo DAB]';
    
    RGBtoHDAB = inv(HDABtoRGB);

    % separate stains = perform color deconvolution
%     tic
    imageHDAB = SeparateStains(imageRGB, RGBtoHDAB);
%     toc

    % % show images
%     fig1 = figure();
%     set(gcf,'color','w');
%     subplot(2,4,1); imshow(imageRGB); title('Original');
%     subplot(2,4,2); imshow(imageHDAB(:,:,1),[]); title('Hematoxylin');
%     subplot(2,4,3); imshow(imageHDAB(:,:,2),[]); title('DAB');
%     subplot(2,4,4); imshow(imageHDAB(:,:,3),[]); title('Residual');
% 
%     subplot(2,4,5); imhist(rgb2gray(imageRGB)); title('Original');
%     subplot(2,4,6); imhist(imageHDAB(:,:,1)); title('Hematoxylin');
%     subplot(2,4,7); imhist(imageHDAB(:,:,2)); title('DAB');
%     subplot(2,4,8); imhist(imageHDAB(:,:,3)); title('Residual');


    % combine stains = restore the original image
%     tic
%     imageRGB_restored = RecombineStains(imageHDAB, HDABtoRGB);
%     toc
% 
%     fig2 = figure()
%     subplot(1,2,1); imshow(imageRGB); title('Orig');
%     subplot(1,2,2); imshow(imageRGB_restored); title('restored');

end
%%
function imageOut = SeparateStains(imageRGB, Matrix)

    % convert input image to double precision float
    % add 2 to avoid artifacts of log transformation
    imageRGB = double(imageRGB)+2;

    % perform color deconvolution
    imageOut = reshape(-log(imageRGB),[],3) * Matrix;
    imageOut = reshape(imageOut, size(imageRGB));

    % post-processing
    imageOut = normalizeImage(imageOut,'stretch');
end

%%
function imageOut = normalizeImage(imageIn, opt)

    imageOut = imageIn;
    for i=1:size(imageIn,3)
        Ch = imageOut(:,:,i);
        % normalize output range to 0...1
        imageOut(:,:,i) = (imageOut(:,:,i)-min(Ch(:)))/(max(Ch(:)-min(Ch(:))));
        % invert image
        imageOut(:,:,i) = 1 - imageOut(:,:,i);
        % optional: stretch histogram
        if strcmp(opt,'stretch')
            imageOut(:,:,i) = imadjust(imageOut(:,:,i),stretchlim(imageOut(:,:,i)),[]);
        end
    end
end

%%
% caution: recombination of low contrast images does not preserve 
% low contrast, but enhances contrast in each channel. This should
% be corrected.

function imageOut = RecombineStains(imageIn, Matrix)

	lo = min(imageIn(:));
	hi = max(imageIn(:));

	if ~(lo>0) && ~(hi<1) % image range is 0...1 -> continue
		if isa(class(imageIn),'double') % image is double -> continue
			% input is alright, continue
			imageOut = -reshape(imageIn,[],3) * Matrix;
			imageOut = exp(imageOut);
			imageOut = reshape(imageOut, size(imageIn));
			imageOut = normalizeImage(imageOut, 'stretch');
		else % image is not double
			warning('image is not double')
			imageOut = imageIn;
		end	
	else % image range is below 0 or above 1
		warning('image out of bounds')
		imageOut = imageIn;
	end	
end