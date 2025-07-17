% function E = computeEME(IM)
% 
% EME - Measure of Enhancement
% Usually used to estimate contrast of an image, and it can evaluate 
% naturalness and uniform lighting.
% Usually, the higher, the better is the contrast
% 
% References:
%   Original: S. S. Agaian, K. Panetta, and A. M. Grigoryan, "A new measure 
% of image enhancement," in Proc. Intl. Conf. Signal Processing 
% Communication, 2000. 
% 
%   Another representation (this is the one used in this implementation): 
% S. S. Agaian, B. Silver, and K. A. Panetta, "Transform coefficient 
% histogram-based image enhancement algorithms using contrast entropy," 
% TIP, 2007.
% 
function E = computeEME(IM)
    L = 8;
    IM = double(IM);
    [ny,nx] = size(IM);
    E = 0.0;
    
    y1 = 1;
    cont = 0;
    while(y1 < ny)
        y2 = min(y1+L-1,ny);
        x1 = 1;
        while(x1 < nx)
            x2 = min(x1+L-1,nx);
            
            B1 = IM(y1:y2,x1:x2);
            b_min = min(min(B1));
            b_max = max(max(B1));
            
            if (b_min > 0)
                b_ratio = b_max / b_min;
                E = E + 20.0 * log(b_ratio);	  
            end;
            
            cont = cont + 1;
            x1 = x1 + L;
        end
        
        y1 = y1 + L;
    end
    E = E / cont;

end