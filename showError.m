function [  ] = showError( flowGTfilename, flowEstfilename )

disp('Load and show optical flow field ... ');
F_est = flow_read(flowEstfilename);
F_gt  = flow_read(flowGTfilename);
tau = 3;
f_err = flow_error(F_gt,F_est,tau);
F_err = flow_error_image(F_gt,F_est);
figure,imshow([flow_to_color([F_est;F_gt]);F_err]);
title(sprintf('Error: %.2f %%',f_err*100));
figure,flow_error_histogram(F_gt,F_est);


end

