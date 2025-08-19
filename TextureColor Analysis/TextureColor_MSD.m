% DESC = TextureColor_MSD(IMAGE)
% Calcula o conjunto de histogramas de uma imagem utilizando 
% Micro-structure Descriptor (MSD).
% 
% IMAGE: matriz [N x N] contendo uma imagem RGB [0-255], no formato uint8.
% 
% DESC: vetor linha contendo os 72 descritores obtidos a partir da imagem
% IMAGE usando o método de Micro-structure Descriptor (MSD).
% 
% Ex:
% image = imread('hestain.png');
% hist = TextureColor_MSD(image);
% 
% Paper:
% G. Liu, Z. Li, L. Zhang and Y. Xu, Image Retrieval based on
% Micro-structure Descriptor, Pattern Recognition 44(9)(2011), 2123-2133
% 
% Adaptado de: http://www4.comp.polyu.edu.hk/~cslzhang/code/MSD.rar
function hist = TextureColor_MSD(RGB)
%%
   [wid,hei,~] = size(RGB);
   % RGB is the input original image datas in RGB color space

   CSA = 72;  %the total color quantization  number of HSV color space
   CSB = 6;   %the quantization number of edge orientation

   %--------------------------------------------
   Cn1 = 8;   %the quantization number of H 
   Cn2 = 3;   %the quantization number of S 
   Cn3 = 3;   %the quantization number of V 
   
   HSV=mat_color(RGB, wid, hei); %transform RGB color space to  HSV color space 
   
   ori=Mat_ori_HSV(HSV, CSB, wid, hei);  %edge orientation detection in HSV color space
   
   ImageX=Mat_color_HSV(HSV, Cn1, Cn2, Cn3, wid, hei);  %color quantization in HSV color space 
      
   micro=microstructure(ori, ImageX, wid, hei);   %micro-structure map extraction

   hist=microdescriptor(micro, CSA, wid, hei);    %micro-structure representation
%% ---------------------------------------------------------------------
function HSV = mat_color(RGB, wid, hei)
%% converte de RGB para HSV
HSV = zeros(wid, hei, 3);

for i = 1:wid
   for j = 1:hei
      cMax = 255.0;       
      maxi = max(RGB(i, j, 1), max(RGB(i, j, 2), RGB(i, j, 3)));
      mini = min(RGB(i, j, 1), min(RGB(i, j, 2), RGB(i, j, 3)));
 
      temp = maxi - mini;       
      % V component      
      HSV(i, j, 3) = maxi * 1.0 / cMax;      
      % S component
      if (maxi > 0)                    
         HSV(i, j, 2) = temp * 1.0 / maxi;
      else
         HSV(i, j, 2) = 0.0;
      end       
      %H component
      if (temp > 0)                             
         rr = (maxi - RGB(i, j, 1)) * 1.0 / temp * 1.0;
         gg = (maxi - RGB(i, j, 2)) * 1.0 / temp * 1.0;
         bb = (maxi - RGB(i, j, 3)) * 1.0 / temp * 1.0;
         hh = 0.0; %#ok<NASGU>

         if (RGB(i, j, 1) == maxi)
             hh = bb - gg;
         elseif (RGB(i, j, 2) == maxi)
             hh = rr - bb + 2.0;
         else
             hh = gg - rr + 4.0;
         end               
         if (hh < 0)                        
             hh = hh + 6;
         end         
         HSV(i, j, 1) = hh / 6;
      end       
      HSV(i, j, 1) = HSV(i, j, 1)*360.0;  
   end
end      
%% ------------------------------------------------------------------------
function ori = Mat_ori_HSV(HSV, num, wid, hei)
%%
  ori=zeros(wid,hei);
  gxx = 0.0; gyy = 0.0; gxy = 0.0;  %#ok<NASGU>  
  rh = 0.0;  gh = 0.0;  bh = 0.0;  %#ok<NASGU>
  rv = 0.0;  gv = 0.0;  bv = 0.0;  %#ok<NASGU>
  theta = 0.0; %#ok<NASGU>  
  hsv=zeros(wid,hei,3);  
  for i = 1:wid  %HSV based on cylinder 
     for j = 1:hei             
        hsv(i, j, 1) = HSV(i, j, 2) * cos(HSV(i, j, 1));
        hsv(i, j, 2) = HSV(i, j, 2) * sin(HSV(i, j, 1));
        hsv(i, j, 3) = HSV(i, j, 3);
     end           
  end
  
  for i = 2:(wid - 1)     
     for j = 2:(hei - 1)                
        %--------------------------------------
        rh = (hsv(i - 1, j + 1, 1) + 2 * hsv(i, j + 1, 1) + hsv(i + 1, j + 1, 1)) - (hsv(i - 1, j - 1, 1) + 2 * hsv(i, j - 1, 1) + hsv(i + 1, j - 1, 1));
        gh = (hsv(i - 1, j + 1, 2) + 2 * hsv(i, j + 1, 2) + hsv(i + 1, j + 1, 2)) - (hsv(i - 1, j - 1, 2) + 2 * hsv(i, j - 1, 2) + hsv(i + 1, j - 1, 2));
        bh = (hsv(i - 1, j + 1, 3) + 2 * hsv(i, j + 1, 3) + hsv(i + 1, j + 1, 3)) - (hsv(i - 1, j - 1, 3) + 2 * hsv(i, j - 1, 3) + hsv(i + 1, j - 1, 3));
        %-----------------------------------------
        rv = (hsv(i + 1, j - 1, 1) + 2 * hsv(i + 1, j, 1) + hsv(i + 1, j + 1, 1)) - (hsv(i - 1, j - 1, 1) + 2 * hsv(i - 1, j, 1) + hsv(i - 1, j + 1, 1));
        gv = (hsv(i + 1, j - 1, 2) + 2 * hsv(i + 1, j, 2) + hsv(i + 1, j + 1, 2)) - (hsv(i - 1, j - 1, 2) + 2 * hsv(i - 1, j, 2) + hsv(i - 1, j + 1, 2));
        bv = (hsv(i + 1, j - 1, 3) + 2 * hsv(i + 1, j, 3) + hsv(i + 1, j + 1, 3)) - (hsv(i - 1, j - 1, 3) + 2 * hsv(i - 1, j, 3) + hsv(i - 1, j + 1, 3));
        %---------------------------------------
        gxx = sqrt(rh * rh + gh * gh + bh * bh);
        gyy = sqrt(rv * rv + gv * gv + bv * bv);
        gxy = rh * rv + gh * gv + bh * bv;
        theta = (acos(gxy / (gxx * gyy + 0.0001)) * 180.0 / pi);
        ori(i, j) = uint32(round(theta * num / 180.0));

        if (ori(i, j) >= num - 1) 
            ori(i, j) = num - 1;
        end   
     end
  end
%% ------------------------------------------------------------------------
function img = Mat_color_HSV(HSV, colnum1, colnum2, colnum3, wid, hei)
%%
 img=zeros(wid,hei); 
 VI = 0; SI = 0; HI = 0; %#ok<NASGU>
 for i = 1:wid
   for j = 1:hei
      VI = uint32(HSV(i, j, 1) * (colnum1 / 360.0));      
      if (VI >= colnum1 - 1)         
          VI = colnum1 - 1;
      end              
      %------------------------------------------      
      SI = uint32(HSV(i, j, 2) * (colnum2 / 1.0));
      if (SI >= colnum2 - 1)                
          SI = colnum2 - 1;
      end              
      %------------------------------------------      
      HI = uint32(HSV(i, j, 3) * (colnum3 / 1.0));
      if (HI >= colnum3 - 1)                 
          HI = colnum3 - 1;
      end      
      img(i, j) = (colnum3 * colnum2) * VI + colnum3 * SI + HI;      
   end
 end
%% ------------------------------------------------------------------------
function micro = microstructure(ori, ImageX, wid, hei)
%%
   ColorA = zeros(wid, hei); %#ok<NASGU>
   ColorB = zeros(wid, hei); %#ok<NASGU>
   ColorC = zeros(wid, hei); %#ok<NASGU>
   ColorD = zeros(wid, hei); %#ok<NASGU>
   ColorA=Map(ori, ImageX, wid, hei, 0, 0);
   ColorB=Map(ori, ImageX, wid, hei, 0, 1);
   ColorC=Map(ori, ImageX, wid, hei, 1, 0);
   ColorD=Map(ori, ImageX, wid, hei, 1, 1);   
   %==========the final micro-structure map===============
   micro = zeros(wid, hei);   
   for i = 1:wid
       for j = 1:hei  
           micro(i, j) = max(ColorA(i, j), max(ColorB(i, j), max(ColorC(i, j), ColorD(i, j))));
       end
   end
 %% -----------------------------------------------------------------------
 function hist = microdescriptor(ColorX, CSA, wid, hei)
%%
  hist=zeros(1,CSA);  
  MS = zeros(CSA);
  HA = zeros(CSA);  
  %----------------------------------------
  for i = 1:(wid-1)
      for j = 1:(hei-1)
        if (ColorX(i, j) >= 0)
           HA(ColorX(i, j)+1) = HA(ColorX(i, j)+1)+1; %coloquei +1
        end
      end
  end  
  %----------------------------------------  
  for i = 4:(3 * (wid / 3) - 1)            
      for j = 4:(3 * (hei / 3) - 1)               
         wa = zeros(1,9);
         wa(1) = ColorX(i - 1, j - 1);
         wa(2) = ColorX(i - 1, j);
         wa(3) = ColorX(i - 1, j + 1);
         wa(4) = ColorX(i + 1, j - 1);
         wa(5) = ColorX(i + 1, j);
         wa(6) = ColorX(i + 1, j + 1);
         wa(7) = ColorX(i, j - 1);
         wa(8) = ColorX(i, j + 1);
         wa(9) = ColorX(i, j);         
         %-------------------------
         TE1 = 0;
         for m = 1:9                     
             if ((wa(9) == wa(m)) && (wa(9) >= 0))
                TE1 = TE1 + 1;
             end 
         end         
         if (wa(9) >= 0)                    
             MS(wa(9)+1) = MS(wa(9)+1)+TE1; %coloquei +1
         end
      end
  end  
  %the features vector of MSD 
  for i = 1:CSA
      hist(i) = (MS(i) * 1.0) / (8.0 * HA(i) + 0.0001);
  end
%% ------------------------------------------------------------------------
function Color = Map(ori, img, wid, hei, Dx, Dy)
%%
  Color = zeros(wid,hei);   
  for i = 2:((wid / 3)-1) %observar
    for j = 2:((hei / 3)-1) %observar
       WA = zeros(1,9);         
       %==============
       m = 3 * i + Dx;
       n = 3 * j + Dy;       
       WA(1) = ori(m - 1, n - 1);
       WA(2) = ori(m - 1, n);
       WA(3) = ori(m - 1, n + 1);
       WA(4) = ori(m + 1, n - 1);
       WA(5) = ori(m + 1, n);
       WA(6) = ori(m + 1, n + 1);
       WA(7) = ori(m, n - 1);
       WA(8) = ori(m, n + 1);
       WA(9) = ori(m, n);       
       %-------------------------
       if (WA(9) == WA(1))
          Color(m - 1, n - 1) = img(m - 1, n - 1);
       else                    
          Color(m - 1, n - 1) = -1;
       end
       %--------------------
       if (WA(9) == WA(2))
          Color(m - 1, n) = img(m - 1, n);           
       else                    
          Color(m - 1, n) = -1;
       end
       %----------------------
       if (WA(9) == WA(3))                    
          Color(m - 1, n + 1) = img(m - 1, n + 1);                
       else                    
          Color(m - 1, n + 1) = -1;
       end
       %----------------------
       if (WA(9) == WA(4))                    
          Color(m + 1, n - 1) = img(m + 1, n - 1);       
       else                    
          Color(m + 1, n - 1) = -1;
       end
       %-------------------------
       if (WA(9) == WA(5))                  
          Color(m + 1, n) = img(m + 1, n);                 
       else                    
          Color(m + 1, n) = -1;
       end
       %--------------------------
       if (WA(9) == WA(6))                    
          Color(m + 1, n + 1) = img(m + 1, n + 1);                    
       else                    
          Color(m + 1, n + 1) = -1;
       end
       %-----------------------------------------
       if (WA(9) == WA(7))
          Color(m, n - 1) = img(m, n - 1);
       else                  
          Color(m, n - 1) = -1;
       end
       %----------------------------------------
       if (WA(9) == WA(8))                    
          Color(m, n + 1) = img(m, n + 1);                 
       else                    
          Color(m, n + 1) = -1;
       end
       %------------------------------------------
       if (WA(9) == WA(9)) 
           Color(m, n) = img(m, n);
       end       
    end
  end