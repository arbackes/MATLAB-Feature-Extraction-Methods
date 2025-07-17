% va = computeAMBE(im1,im2)
% 
% AMBE - Absolute Mean Brightness Error
% Used to estimate the difference between two images (im1 and im2)
% The lower the better
% 
% Reference:
% N. Phanthuna, F. Cheevasuvit, and S. Chitwong, "Contrast enhancement 
% for minimum mean brightness error from histogram partitioning," ASPRS 
% Conf. 2009.

function va = computeAMBE(im1,im2)
    
    me1 = mean(double(im1(:)));
    me2 = mean(double(im2(:)));

    va = abs(me1 - me2);
end