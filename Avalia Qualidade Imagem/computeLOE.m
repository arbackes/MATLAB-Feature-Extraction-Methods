% function LOE = computeLOE(ipic,epic)
% 
% LOE - Lightness Order Error
% Since the relative order of lightness represents the light source 
% directions and the lightness variation, the naturalness of an enhanced 
% image is related to the relative order of lightness in different local 
% areas. The LOE is therefore based on the lightness order error between 
% the original image I and its enhanced version Ie to assess the 
% naturalness. Basically, the lower, the better.
% 
% Parameters:
% ipic: input image
% epic: enhanced image
% 
% Source:
% https://shuhangwang.wordpress.com/2015/12/14/naturalness-preserved-image-enhancement-using-a-statistical-lightness-variation-prior/
% 
% Reference:
% S. Wang, J. Zheng, H. Hu, and B. Li, “Naturalness preserved enhancement 
% algorithm for non-uniform illumination image,” IEEE Trans. Images 
% Process., vol. 22, no. 9. Sep. 2013.

function LOE = computeLOE(ipic,epic)
    %input image
%     ipic=imread('Input.bmp');
    ipic=double(ipic);
    %enhanced image
%     epic=imread('Enhanced.JPG');
    epic=double(epic);

    [m,n,k] = size(ipic);


    %get the local maximum for each pixel of the input image
    win = 7;
    imax = round(max(max(ipic(:,:,1),ipic(:,:,2)),ipic(:,:,3)));
    imax = getlocalmax(imax,win);
    %get the local maximum for each pixel of the enhanced image
    emax=round(max(max(epic(:,:,1),epic(:,:,2)),epic(:,:,3)));
    emax=getlocalmax(emax,win);

    %get the downsampled image
    blkwin=50;
    mind=min(m,n);
    step=floor(mind/blkwin);% the step to down sample the image
    blkm=floor(m/step);
    blkn=floor(n/step);
    ipic_ds=zeros(blkm,blkn);% downsampled of the input image
    epic_ds=zeros(blkm,blkn);% downsampled of the enhanced image
    LOE=zeros(blkm,blkn);%

    for i=1:blkm
        for j=1:blkn
            ipic_ds(i,j)=imax(i*step,j*step);
            epic_ds(i,j)=emax(i*step,j*step);
        end
    end

    for i=1:blkm
        for j=1:blkn%bug
            flag1=ipic_ds>=ipic_ds(i,j);
            flag2=epic_ds>=epic_ds(i,j);
            flag=(flag1~=flag2);
            LOE(i,j)=sum(flag(:));
        end
    end

    LOE = mean(LOE(:));
end

function output=getlocalmax(pic,win)
    [m,n]=size(pic);
    extpic=getextpic(pic,win);
    output=zeros(m,n);
    for i=1+win:m+win
        for j=1+win:n+win
            modual=extpic(i-win:i+win,j-win:j+win);
            output(i-win,j-win)=max(modual(:));
        end
    end
end

function output=getextpic(im,win_size)
    [h,w,c]=size(im);
    extpic=zeros(h+2*win_size,w+2*win_size,c);
    extpic(win_size+1:win_size+h,win_size+1:win_size+w,:)=im;
    for i=1:win_size%extense row
        extpic(win_size+1-i,win_size+1:win_size+w,:)=extpic(win_size+1+i,win_size+1:win_size+w,:);%top edge
        extpic(h+win_size+i,win_size+1:win_size+w,:)=extpic(h+win_size-i,win_size+1:win_size+w,:);%botom edge
    end
    for i=1:win_size%extense column
        extpic(:,win_size+1-i,:)=extpic(:,win_size+1+i,:);%left edge
        extpic(:,win_size+w+i,:)=extpic(:,win_size+w-i,:);%right edge
    end
    output=extpic;
end
