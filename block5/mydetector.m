function mask = mydetector(frame, bestalpha, bestrho)

global means
global variances
global sigmas

curMeans = means;
curVariances = variances;
curSigmas = sigmas;

frame = rgb2gray(frame);
frame = double(frame*255);
[width,height] = size(frame); % get width and height of image

curImage = frame;
for m=1:width %For each pixel
    for n=1:height
        if abs(curImage(m,n) - curMeans(m,n)) >= (bestalpha*(curSigmas(m,n)+2)) %+2 to prevent low values
            curImage(m,n) = 255;    %pixel is Foreground
        else
            curImage(m,n) = 0;    %pixel is Background

            curMeans(m,n) = bestrho * frame(m,n)+(1-bestrho)* curMeans(m,n); % update means
            curVariances(m,n) = bestrho*power(frame(m,n) - curMeans(m,n),2) + ...
                                    (1-bestrho) * curVariances(m,n); % update variances
            curSigmas(m,n) = sqrt(curVariances(m,n));
        end
    end
end

mask = curImage;

means = curMeans;
variances = curVariances;
sigmas = curSigmas;

end