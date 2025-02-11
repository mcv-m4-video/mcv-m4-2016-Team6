function f_err = flow_error (F_gt,F_est,tau)

[E,F_val] = flow_error_map (F_gt,F_est);
disp(['MSEN: ' +num2str(sum(E(:)))]);
f_err = length(find(E>tau))/length(find(F_val));
