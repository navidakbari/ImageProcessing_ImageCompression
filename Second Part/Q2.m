%%
clear;
clc;
close all;
%% 1 
%vared shodan tasvir 
orgphoto = (imread('denoised_photo.jpg'));

orgphoto=rgb2gray(orgphoto);
[PhotoRow, PhotoCol] = size(orgphoto);

%zero padding baraye tanzim size
if(mod(PhotoRow,8) ~= 0)
    while(mod(PhotoRow,8)~=0)
        orgphoto=[orgphoto ; zeros(1,PhotoCol)];
        [PhotoRow PhotoCol]=size(orgphoto);
    end
end


if(mod(PhotoCol,8) ~= 0)
    while(mod(PhotoCol,8)~=0)
        orgphoto=[orgphoto  zeros(PhotoRow,1)];
        [PhotoRow PhotoCol]=size(orgphoto);
    end
end

[PhotoRow, PhotoCol] = size(orgphoto);
SourceImage=orgphoto;               
%% 2   
%tanzim shedat roshanae       
for x = 1 : 1 : PhotoRow
    for y = 1 : 1 : PhotoCol
        if orgphoto(x , y) < 128
            orgphoto(x , y) = 0;
        else
            orgphoto(x , y) = orgphoto(x , y) - 128;
        end    
    end
end
%% 3
%emal tabdil gossaste cos ba dastoor dct2

for x = 1 : 8 : PhotoRow
    for y = 1 : 8 : PhotoCol
        temp = orgphoto(x : x+7 , y : y+7);
        temp = dct2(temp);
        orgphoto(x : x + 7 , y : y + 7) = temp;
    end
end
%% 4    
%entekhab kardan keifiat negahdari va quantized kardan tasvir
quality = input('What quality of compression you require? ');

Q50 = [ 16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 80 62; 
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 103 121 120 101;
        72 92 95 98 112 100 103 99];
 
if quality > 50
    QX = round(Q50.*(ones(8)*((100-quality)/50)));
    QX = uint8(QX);
elseif quality < 50
    QX = round(Q50.*(ones(8)*(50/quality)));
    QX = uint8(QX);
elseif quality == 50
    QX = uint8(Q50);
end

for x = 1 : 8 : PhotoRow
    for y = 1 : 8 : PhotoCol
        temp = orgphoto( x : x + 7 , y : y + 7);
        temp2 = round( temp ./ QX);
        quantized(x : x + 7 , y : y + 7) = temp2;
    end
end

quantized = mat2cell(quantized , 8 * ones(1, PhotoRow/8) , 8 * ones(1, PhotoCol/8));

%% 5
%tabdil har bakhsh 8*8 be bordar 1*64 ba zig-zag pattern va negahdari an dar matris
[row col]=size(quantized);
for i = 1 : row
    for j=1 : col
        quantized(i,j)=mat2cell(zigzag(cell2mat(quantized(i,j))),1,64);        
    end
end

 
%negahdari bordarhaye 1*64 besoorat yek bordar ba komak zig-zag pattern
cellindex = reshape(1:row*col, row , col);

cellindex_vector = zigzag(cellindex);
 
quantized_vector=[];
for i = 1 : length(cellindex_vector)
    quantized_vector(64*(i-1) + 1 : 64*i) = cell2mat(quantized(cellindex_vector(i)));
end

%% 6 
%tolid huffman dictionary va negahdari tavali bordari adadi besoorat tavali binary
%ba komak huffman codding
string=quantized_vector;
symbol=[];                                
count=[];
j=1;

for i=1:length(string)                   
  flag=0;    
  flag=ismember(symbol,string(i));      
      if sum(flag)==0
      symbol(j) = string(i);
      k=ismember(string,string(i));
      c=sum(k);                           
      count(j) = c;
      j=j+1;
      end 
end    
ent=0;
total=sum(count);                         
prob=[];                                         


for i=1:1:size((count)');                   
prob(i)=count(i)/total;
ent=ent-prob(i)*log2(prob(i));     
end
var=0;

[dict avglen]=huffmandict(symbol,prob); 
quantized_vector=string;
%% 7
photo_encoded=huffmanenco(quantized_vector,dict);

%% 8
%tabdil tavali binary be addadi ba huffman decoding

photo_deco=huffmandeco(photo_encoded,dict);


%% 9
%tabdil kardan tavali adadi be matris ba komak inverse zig-zag patter

quantized_vector2cell=mat2cell(photo_deco,[1],64*ones(1,length(quantized_vector)/64));
invcell_index=reshape(1:length(quantized_vector2cell),1,length(quantized_vector2cell));
invcell_mat=invzigzag(invcell_index,PhotoRow/8,PhotoCol/8);
[row col]=size(invcell_mat);
quantized_cell={};
for i=1 : row
   for j=1 : col
      quantized_cell(i,j)=quantized_vector2cell(invcell_mat(i,j));
   end
end
[row col]=size(quantized_cell);
dequantized=[];
for i=1 : row
    for j=1 : col
    tempVector=cell2mat(quantized_cell(i,j)); 
    dequantized(8*(i-1)+1:8*i,8*(j-1)+1:8*j)=invzigzag(tempVector,8,8);
    end
end
dequantized=uint8(dequantized);
%% 10
%dequantized kardan tasvir

temp=[];
temp2=[];
[row col]=size(dequantized);
for x = 1 : 8 : row
    for y = 1 : 8 : col
        temp = dequantized( x : x + 7 , y : y + 7);
        temp2 = round( temp .* QX);
        dequantized(x : x + 7 , y : y + 7) = temp2;
    end
end

%% 11
%akse tabdil gosasteh cosinosi
for x = 1 : 8 : row
    for y = 1 : 8 : col
        temp = dequantized(x : x+7 , y : y+7);
        temp = idct2(temp);
        dequantized(x : x + 7 , y : y + 7) = temp;
    end
end 
%% 12
%tanzim roshane tasvir
%namayesh tasvir vared shode va tasviri ke ebteda feshorde shode va az
%feshordegi kharej shode
ReconstructedImage=dequantized+128;
%% 13
figure
imshow(SourceImage)
title('Source Image')
figure
imshow(ReconstructedImage)
title('Reconstructed Image')

e=ReconstructedImage-SourceImage;
eTOT=0;
[row col]=size(e);
for x=1 : row
    for y=1 : col
       eTOT=eTOT + e(x,y)^2;         
    end
end
eRMS=(1/(row*col))*sqrt(double(eTOT));
display(eRMS)


