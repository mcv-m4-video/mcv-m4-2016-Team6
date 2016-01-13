function [ shadow_images ] = removeShadows( image_back,image_in )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[fil,col,dim] = size(image_back);
aux = zeros(fil,col,dim);

for i=1:fil
    for j=1:col
        
        back = [image_back(i,j,1),image_back(i,j,2),image_back(i,j,3)];
        in = [image_in(i,j,1),image_in(i,j,2),image_in(i,j,3)];
        
        % Compute BD.
        A = in;
        B = back;
        CosTheta = dot(A,B)/(norm(A)*norm(B));
%         ThetaInDegrees = acos(CosTheta)*180/pi;
        BD = norm(A)*cos(CosTheta);
        BD1 = BD/norm(B);
        
        % Compute CD. Euclidean distance between two vectors.
        CD = norm(A - BD);
        
        if CD < 10
            if BD1 < 1.0 && BD1 > 0.5
                % shadow
                aux(i,j,:) = [0,255,0];
            end
            if BD1 < 1.25 && BD1 > 1
                % highlighting
                aux(i,j,:) = [255,0,0];
            end
        else
            % foreground
            aux(i,j,:) = [0,0,255];
        end

    end
end

shadow_images = aux;

end

