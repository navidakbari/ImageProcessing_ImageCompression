clear;
clc;
close all;
%%
%khandane ax asli va ax noise dar va hesab kardan tabdil fourier

noised_photo = imread('car.jpg');
org_photo = imread('Original.jpg');

noised_photo = fft2(noised_photo);
noised_photo = fftshift(noised_photo);

figure , imshow(noised_photo);

%%
%hazf noise sin

for x = 1 : 1 : 800
    for y = 1 : 1 : 1600
        if x < 170 && x>90 && y < 300 && y > 220
            noised_photo(x , y) = 0;
        elseif x < 710 && x > 630 && y > 1300 && y < 1380
            noised_photo(x,y) = 0;
        elseif y < 265 && y > 255
            noised_photo(x,y) = 0;
        elseif y < 1345 && y > 1335
            noised_photo(x,y) = 0;
        end
    end
end

figure , imshow(noised_photo);

noised_photo = ifft2(ifftshift((noised_photo)));

figure , imshow(uint8(noised_photo));

%%
%hazf noise harekati

PSF = fspecial('motion' , 100 , 150);

noised_photo = deconvwnr(uint8(real(noised_photo)), PSF , 0.004);

imshow((noised_photo));

%%
%mohasebe khata

MSE = mse(uint8(noised_photo) , org_photo);
SNR = snr(uint8(noised_photo) , org_photo);

display(MSE , 'MSE');
display(SNR , 'SNR');

%%
% code haye avalie ke estefade nashud

% syms coe u0 v0 x y
% 
% coe = 30i*pi;
% u0 = 1.95;
% v0 = 1.95;
% 
% sinnoise = zeros(800,1600);
% 
% for x = 1 : 1 : 800
%     for y = 1 : 1 : 1600
%         sinnoise(x , y) = coe*sin( u0*x + v0*y);
%     end
% end
% 
% sinnoise = fft2(sinnoise);
% 
% noised_photo = noised_photo - sinnoise;
% 
% noised_photo = ifft2(ifftshift(noised_photo));
% 
% 
% syms T a b u v
% 
% H = zeros(800 , 1600);
% 
% T = 10i*pi;
% a = 0;
% b = 2;
% 
% for u = 1 : 1 : 800
%     for v = 1 : 1 : 1600
%         H(u , v) = (T/pi*(u*a + v*b))*sin(pi*(u*a + v*b))*exp(-1i*pi*(u*a+v*b));
%     end
% end
% fspecial
% 
% noised_photo = noised_photo ./ H;
% 
% noised_photo = ifft2(ifftshift(noised_photo));
% 
% imshow( ((noised_photo)));