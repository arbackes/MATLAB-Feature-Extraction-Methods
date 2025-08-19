function Fe = TextureColor_HaralickLBP(im)
% DESC = TextureColor_HaralickLBP(IMAGE)
% Calcula o conjunto de descritores de uma imagem colorida utilizando o método de Haralick + LBP, 
% para um conjunto de sistemas de cores e features previamente definidos.
% 
% IMAGE: matriz [N x N x 3] contendo uma imagem RGB [0-255], no formato uint8.
%
% DESC: conjunto de 10 descritores histogramas obtido a partir da imagem IMAGE. 
% 
% Ex:
% image = imread('hestain.png');
% desc = TextureColor_HaralickLBP(image);
% 
% Paper:
% Alice Porebski, Nicolas Vandenbroucke and Ludovic Macaire, 
% Haralick feature extraction from LBP images for color texture 
% classification, IEEE Image Processing Theory, Tools & Applications, 2008;
im = double(im);
lbp_XYZ = computeVectorialLBP(convertRGB2XYZ(im));
lbp_YUVgamma = computeVectorialLBP(convertRGB2YUVgamma(im));
lbp_lch = computeVectorialLBP(convertRGB2LCH(im));
lbp_xyz = computeVectorialLBP(convertRGB2xyz(im));
lbp_Luv = computeVectorialLBP(rgb2luv(im));
lbp_AC1C2 = computeVectorialLBP(convertRGB2AC1C2(im));
lbp_rgb = computeVectorialLBP(convertRGB2rgb(im));

Fe = zeros(1,10);
Fe(1) = HaralickFeatures(computeMCO8Neighborhood(lbp_XYZ,3),10);
Fe(2) = HaralickFeatures(computeMCO8Neighborhood(lbp_YUVgamma,2),10);
Fe(3) = HaralickFeatures(computeMCO8Neighborhood(lbp_lch,4),7);
Fe(4) = HaralickFeatures(computeMCO8Neighborhood(lbp_xyz,2),12);
Fe(5) = HaralickFeatures(computeMCO8Neighborhood(lbp_Luv,1),3);
Fe(6) = HaralickFeatures(computeMCO8Neighborhood(lbp_AC1C2,5),3);
Fe(7) = HaralickFeatures(computeMCO8Neighborhood(lbp_AC1C2,4),3);
Fe(8) = HaralickFeatures(computeMCO8Neighborhood(lbp_xyz,1),12);
Fe(9) = HaralickFeatures(computeMCO8Neighborhood(lbp_rgb,5),7);
Fe(10) = HaralickFeatures(computeMCO8Neighborhood(lbp_AC1C2,1),5);

%% ------------------------------------------------------------------------
function VectorialLBP = computeVectorialLBP(im1)

pesos = [1 2 4; 8 0 16; 32 64 128];

[ny,nx,nz] = size(im1);
w = 1;

VectorialLBP = zeros(ny-2*w,nx-2*w);

for y=(1+w):ny-w
    for x=(1+w):nx-w        
        c = sum(im1(y-w:y+w,x-w:x+w,:).^2,3) >= sum(im1(y,x,:).^2);
        c = c .* pesos;
        VectorialLBP(y-w,x-w) = sum(c(:));
    end;
end;

%% ------------------------------------------------------------------------
function mco = computeMCO8Neighborhood(im,d)

[ny,nx] = size(im);
mask = [-d -d; - d 0; -d d; 0 -d; 0 d; d -d; d 0; d d];
mco = zeros(256,256);

for y=(d+1):ny-d
    for x=(d+1):nx-d
        cor1 = im(y,x) + 1;
        for k=1:7
            cor2 = im(y+mask(k,1),x+mask(k,2)) + 1;
            mco(cor1,cor2) = mco(cor1,cor2) + 1;
        end;        
    end;
end;

mco = mco / sum(mco(:));
%% ------------------------------------------------------------------------
function XYZ = convertRGB2XYZ(im)
% RGB -> XYZ
[ny,nx,~] = size(im);
mask  = [0.607, 0.174, 0.200; 0.299, 0.587, 0.114; 0, 0.066, 1.111];
XYZ = zeros(ny,nx,3);
for y=1:ny
    for x=1:nx
        XYZ(y,x,:) = mask * squeeze(im(y,x,:));
    end;
end;

%% ------------------------------------------------------------------------
function xyz = convertRGB2xyz(im)
% RGB -> xyz(XYZ normalizado pela soma)
[ny,nx,~] = size(im);
mask  = [0.607, 0.174, 0.200; 0.299, 0.587, 0.114; 0, 0.066, 1.111];
xyz = zeros(ny,nx,3);
for y=1:ny
    for x=1:nx
        xyz(y,x,:) = mask * squeeze(im(y,x,:));
        xyz(y,x,1) = xyz(y,x,1) / sum(xyz(y,x,:));
        xyz(y,x,2) = xyz(y,x,2) / sum(xyz(y,x,:));
        xyz(y,x,3) = xyz(y,x,3) / sum(xyz(y,x,:));
    end;
end;
    
%% ------------------------------------------------------------------------
function im = convertRGB2rgb(im)
% RGB -> rgb (RGB normalizado pela soma)
[ny,nx,~] = size(im);
for y=1:ny
    for x=1:nx        
        im(y,x,:) = im(y,x,:) / sum(im(y,x,:));
    end;
end;

%% ------------------------------------------------------------------------
function YUVgamma = convertRGB2YUVgamma(im)
% YUVnorm => Y'U'V'
% Correção gama no RGB antes que calcular o YUV

[ny,nx,~] = size(im);
YUVgamma = zeros(ny,nx,3);
% correção gamma: RGB to R'G'B'
hgamma = video.GammaCorrector('Correction','Gamma');
im = step(hgamma, im);

mask = [0.299, 0.587, 0.114; -0.147, -0.289, 0.436; 0.615, -0.515, -0.100];

for y=1:ny
    for x=1:nx        
        YUVgamma(y,x,:) = mask * squeeze(im(y,x,:));
    end;
end;

%% ------------------------------------------------------------------------
function Luv_back = rgb2luv(Im_rgb)
% takes an image in Rgb coords and returns either a vector or an image
% in Luv coords, depending on Type (Image or vector).

Vector = shiftdim(Im_rgb, 2);
Vector = double(reshape(Vector, [3, size(Im_rgb, 1)*size(Im_rgb, 2)]));
Vector_nz = 4096*(sum(Vector, 1) > 0);
Vector_z = not(Vector_nz);
Vector = max(Vector, [Vector_z; Vector_z; Vector_z]);	% to avoid all zero pixels

Matrix = [...
      0.490 0.310 0.200; ...
      0.177 0.812 0.011; ...
      0.000 0.010 0.990];

XYZ = Matrix*Vector;		% now get a vector in XYZ coords

Y0 = 1;		% is it true?
X0 = 1;
Z0 = 1;

u0 = 4*X0/(X0+15*Y0+3*Z0);
v0 = 9*Y0/(X0+15*Y0+3*Z0);

Luv_back = zeros(size(Vector));
Luv_back(1, :) = 25*(100*XYZ(2, :)/Y0).^(0.333)-16;
Zeros = zeros(size(Luv_back(1, :)));
Luv_back(1, :) = max(Luv_back(1, :), Zeros);
u = 4*XYZ(1, :) ./ (XYZ(1, :)+15*XYZ(2, :)+3*XYZ(3, :));
v = 9*XYZ(2, :) ./ (XYZ(1, :)+15*XYZ(2, :)+3*XYZ(3, :));
Luv_back(2, :) = 13*Luv_back(1, :).*(u-u0);
Luv_back(2, :) = max(Luv_back(2, :), Zeros);
Luv_back(3, :) = 13*Luv_back(1, :).*(v-v0);
Luv_back(3, :) = max(Luv_back(3, :), Zeros);
Luv_back = min(Luv_back, [Vector_nz; Vector_nz; Vector_nz]);	% zeroing out
Luv_back = Luv_back/(718.3176/256);
Luv_back = reshape(Luv_back, [3, size(Im_rgb, 1), size(Im_rgb, 2)]);
Luv_back = shiftdim(Luv_back, 1);

%% ------------------------------------------------------------------------
function AC1C2 = convertRGB2AC1C2(im)
% RGB -> AC1C2
[ny,nx,~] = size(im);
mask1 = [0.607, 0.174, 0.200; 0.299, 0.587, 0.114; 0, 0.066, 1.111];
mask2 = [0.2787, 0.7218, -0.1066; -0.4488, 0.2898, 0.0772; 0.0860, -0.5900, 0.5011];
AC1C2 = zeros(ny,nx,3);
for y=1:ny
    for x=1:nx
        AC1C2(y,x,:) = mask1 * squeeze(im(y,x,:));
        AC1C2(y,x,:) = mask2 * squeeze(AC1C2(y,x,:));        
    end;
end;
%% ------------------------------------------------------------------------
function lsh = convertRGB2LCH(im)
% LCH é parecido com o LSH

lsh = colorspace('LCH<-RGB',im);

%% ------------------------------------------------------------------------
function FSel = HaralickFeatures(foo,index)
% *****************************************************
% Calculating the texture features from the SGLD matrix
% *****************************************************

% Entropy 
entropy=sum(sum(-((full(spfun(@log2,foo))).*foo)));

% Energy:
energy=sum(sum(foo.*foo));

% Inertia:
[i,j,v]=find(foo);
inertia=sum((((i-1)-(j-1)).*((i-1)-(j-1))).*v);

% Inverse differnece moment:
inverse_diff=sum((1./(1+(((i-1)-(j-1)).*((i-1)-(j-1))))).*v);

% Correlation:
[m,n]=size(foo);

px=sum(foo,2);
[i,j,v]=find(px);
mu_x=sum((i-1).*v);
sigma_x=sum((((i-1)-mu_x).^2).*v);
h_x=sum(sum(-((full(spfun(@log2,px))).*px)));
temp1=repmat(px,[1 m]);

py=sum(foo,1);
[i,j,v]=find(py);
mu_y=sum((j-1).*v);
sigma_y=sum((((j-1)-mu_y).^2).*v);
h_y=sum(sum(-((full(spfun(@log2,py))).*py)));
temp2=repmat(py,[n 1]);


[i,j,v]=find(foo);
correlation=(sum(((i-1)-mu_x).*((j-1)-mu_y).*v))/sqrt(sigma_x*sigma_y);

% Information measures of correlation 1 and 2:
foo1=-(foo.*(((temp1.*temp2)==0)-1));
foo2=-((temp1.*temp2).*((foo1==0)-1));
[i1,j1,v1]=find(foo1);
[i2,j2,v2]=find(foo2);
h1=sum((sum(-(v1.*(log2(v2))))));
info_corr_1=(entropy-h1)/max(h_x,h_y);
[i,j,v]=find(temp1.*temp2);
h2=sum((sum(-(v.*(log2(v))))));
info_corr_2=sqrt((1-exp(-2*(h2-entropy))));

% Sum average, variance and entropy:
[i,j,v]=find(foo);
k=i+j-1;
pk_sum=zeros(max(k),1);
for l=min(k):max(k)
  pk_sum(l)=sum(v(find(k==l)));
end

[i,j,v]=find(pk_sum);
sum_avg=sum((i-1).*v);
sum_var=sum((((i-1)-sum_avg).^2).*v);
sum_entropy=sum(-((full(spfun(@log2,pk_sum))).*pk_sum));
 
% Difference average, variance and entropy:
[i,j,v]=find(foo);
k=abs(i-j);
pk_diff=zeros(max(k)+1,1);
for l=min(k):max(k)
   pk_diff(l+1)=sum(v(find(k==l)));
end

[i,j,v]=find(pk_diff);
diff_avg=sum((i-1).*v);
diff_var=sum((((i-1)-diff_avg).^2).*v);
diff_entropy=sum(-((full(spfun(@log2,pk_diff))).*pk_diff));    

%**************************************************************************
F= [energy,correlation,inertia,entropy,inverse_diff,sum_avg,...
    sum_var,sum_entropy,diff_avg,diff_var,diff_entropy,info_corr_1,...
    info_corr_2];

FSel = F(index);

