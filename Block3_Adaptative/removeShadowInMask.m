function [ new_mask_image ] = removeShadowInMask( mask_image,shadow_image )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[fil,col,~] = size(mask_image);

for i=1:fil
   for j=1:col
       
       if shadow_image(i,j,2)==255 % shadow
           mask_image(i,j) = 0;
       end
       
   end
end

new_mask_image = mask_image;
end

