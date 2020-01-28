clc;
clear all;
close all;
background_image=imread('scene00316.png');    
    image_to_detect1=imread('scene00036.png'); 

    image1=background_image-image_to_detect1;

     image1=rgb2gray(image1);
    level1=graythresh(image1)*256;
    threshim1=image1>level1;    

         se = strel('diamond',1);
         erodedBW1 = imerode(threshim1,se);
  
    dilatedBW1= imdilate(erodedBW1,se);
 % imshow(dilatedBW1);
      [a1,b1]=size(dilatedBW1);
      F=imfill(dilatedBW1,'holes');
%figure, imshow(F);
      I=bwareaopen(F,floor((a1/58)*(b1/58)));

se = strel('sphere',18);
  IM2 = imclose(I,se);

      blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);
bbox = step(blobAnalysis, IM2);


      numVeh = size(bbox, 1);
     

subplot(1,2,1);
imshow(image_to_detect1);
title('image taken when red light turns ON');

  hold on
u=1;
s1=[30 225];
s2=[480 243];
for i=1:numVeh
    j=1;
 k=zeros(1,4);
    k(j,1)=bbox(i,1);
    k(j,2)=bbox(i,2);
    k(j,3)=bbox(i,3);
    k(j,4)=bbox(i,4);

xplush=k(j,1)+k(j,4);
y=k(j,2);
yplusw=k(j,2)+k(j,3);
blaxix=[xplush,y];  %bottom lleft axix
braxix=[xplush,yplusw]; % bottom right axix


if(blaxix(2)>s1(2)||braxix(2)>s2(2))
   mout(u,1)=k(j,1);
   mout(u,2)=k(j,2);
   mout(u,3)=k(j,3);
   mout(u,4)=k(j,4);
   u=u+1;
end

end
hold on
  result= insertShape(image_to_detect1, 'Rectangle', mout, 'Color', 'red');
subplot(1,2,2);
imshow(result);
title('Processed image highlighting Vehicle that broke Rule ');
line([s1(1),s2(1)],[s1(2),s2(2)],'LineWidth',2,'Color','y');
hold off