clc
clear

load new_Temperature.mat
% 设置参数
A = [7038457.739876, 6.02*10^28, 2.1505*10^21];
E_a = [77643.164476, 243691, 192885];
T1=366.60164;
Tv=397.351850000000;
T2=404.95256;
T_260=445.6;
M=120; % 电池质量g
Cp=1;% 比热容
numtimesteps = 80330;
Temp_0=T1;% 单位k

% 生成时间数据（假设每个时间步长为1秒）
time = 1:numtimesteps;

% 调用 calculateValues 函数来计算温升数据
[sumQ, Q_m, Q, dTemp_dt, Temp] = calculateValues(numtimesteps, A, E_a, Cp, M, Temp_0, T1,Tv,T2,T_260);
Temp=Temp(1:end-1);



 %绘制温升随时间的变化曲线
figure
plot(Temp-273.15,dTemp_dt);
xlabel('温度 (℃)');
ylabel('温升速率 (℃/s)');
title('温升随温度的变化');
grid on;

figure
plot(time, dTemp_dt);
xlabel('时间 (秒)');
ylabel('温升速率 (K/s)');
title('温升随温度的变化');
grid on;

figure
plot(time, Temp);
xlabel('时间 (秒)');
ylabel('温度 (K)');
title('温升随温度的变化');
grid on;

figure
plot(time, Temp-273.15);
xlabel('时间 (秒)');
ylabel('温度 (℃)');
title('温升随温度的变化');
grid on;

figure
plot(Q, Temp);
xlabel('功率 (J/s)');
ylabel('温度 (K)');
title('功率随温度的变化');
grid on;
