%This function makes a avi movie from a sequence of frames.
%The user can control the display time of each frame. The movie is created
%in the same folder where this function is run.
%
%Usage:
%      Inputs:          
%             name_of_avi: name of the avi file you wish to create  
%   display_time_of_frame: duration on seconds of every frame
%           
%           Output:
%  it creates a file named as name_of_avi.avi in the same folder of this function
%          
%This function is written by :
%                             Héctor Corte
%                             Battery Research Laboratory
%                             University of Oviedo
%                             Department of Electrical, Computer, and Systems Engineering
%                             Campus de Viesques, Edificio Departamental 3 - Office 3.2.05
%                             PC: 33204, Gijón (Spain)
%                             Phone: (+34) 985 182 559
%                             Fax: (+34) 985 182 138
%                             Email: cortehector@uniovi.es


function Movie_from_frames(name_of_avi,display_time_of_frame)

[filename, pathname] = uigetfile('*.*','MultiSelect', 'on','Pick a file');

N=length(filename);

%Precharge some variables to improve speed
name1=[pathname,filename{1}];
[a,map]=imread(name1);
mov(1:N) = struct('cdata',a,'colormap',map);

%Main loop to convert images to frames and add them to movie.
for i=1:N
    name1=[pathname,filename{i}];
    [a,map]=imread(name1);
    if map
       mov(i)=im2frame(a,map); 
    else
        mov(i)=im2frame(repmat(a, [1 1 3]));
    end
end
%Convert movie to avi file and save it on current folder
movie2avi(mov, [name_of_avi,'.avi'], 'compression', 'None','fps',1/display_time_of_frame);

    