figure; hold;

legend_str = [];
title('');
for i=20:10:60
    plot(8:8:40, PEPN_1(i, 8:8:40), '-x');
    legend_str = [legend_str; sprintf('BlockSize = %s', num2str(i))];
end

legend(legend_str);
xlabel('Area of Search'); ylabel('PEPN');
