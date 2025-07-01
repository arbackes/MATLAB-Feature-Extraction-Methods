function sel = Threshold_BalancedHistogram(im)
% SEL = Threshold_BalancedHistogram(IM)
% Calcula o threshold de uma imagem em tons de cinza usando o método 
% Balanced Histogram
% 
% IM: matriz [M x N] contendo uma imagem em tons de cinza [0-255], no
% formato uint8
%
% SEL: threshold calculado
% 
% Paper:
% A. Anjos and H. Shahbazkia. Bi-Level Image Thresholding - A Fast Method.
% BIOSIGNALS 2008. Vol:2. P:70-76.

  [h,g] = imhist(im);
  h = h / sum(h);

  maxh = max(h(:));
  h = h./ maxh;
  h(h<0.05) = 0;

  temp = find(h>0);
  i_s = min(temp); % start index
  i_e = max(temp); % end index
  i_m = round((i_s + i_e)/2);
  w_l = sum(h(i_s:i_m));
  w_r = sum(h(i_m+1:i_e));
  while (i_s <= i_e)
      if (w_r > w_l)
          w_r = w_r - h(i_e);
          i_e = i_e -1;
          if (((i_s + i_e)/2) < i_m)
              w_r = w_r + h(i_m);
              w_l = w_l - h(i_m);
              i_m = i_m - 1;
          end
      elseif (w_l >= w_r)
          w_l = w_l - h(i_s);
          i_s = i_s + 1;
          if (((i_s + i_e)/2) > i_m)
              w_r = w_r - h(i_m+1);
              w_l = w_l + h(i_m+1);
              i_m = i_m + 1;
          end
      end
  end
  
  sel = i_m;
  
