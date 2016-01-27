function [files, i] = ListFiles(directory)
    f = dir(directory);
    N = size(f,1);
    files = cell(floor(0.8*N),1);
    i = 0;
    for index=1:N
        if f(index).isdir==0,
            if strcmp(f(index).name(end-2:end),'jpg')==1 || strcmp(f(index).name(end-2:end),'png')==1
                name = f(index).name;                
                i = i + 1;
                files(i) = {strcat(directory, name)};                
            end
        end
    end
end

