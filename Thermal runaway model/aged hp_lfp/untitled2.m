data=shiba_lfp_laohua82;
new_data=interp1(data(:,1),data(:,2),1:92915);
figure;
plot(1:92915, new_data, 'g-');
legend show;
new_data=new_data';
