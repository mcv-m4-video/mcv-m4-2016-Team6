figure
xlabel('xlabel'); ylabel('ylabel'); title('');
axis([0,col,0,row]);
imshow(uint8(image_10));
hold

q = quiver(X, Y, dX(1:blockSize:row, 1:blockSize:col), dY(1:blockSize:row, 1:blockSize:col));
qq = quiver(X, Y, F_gt(1:blockSize:row, 1:blockSize:col, 1), F_gt(1:blockSize:row, 1:blockSize:col,2));

set(q,'linewidth',2);
set(qq,'linewidth',2);
set(q,'color',[1,0,0]);
set(q,'color',[0,1,0]);