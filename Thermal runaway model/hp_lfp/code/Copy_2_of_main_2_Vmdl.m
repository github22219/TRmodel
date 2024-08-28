clc
clear

load HP_lfp_newdata.mat
Temp=new_data(:,1);
dTemp_dt=new_data(:,2);
% 设置参数
A = [999999999999877591780554585407488, 995478638935958.125000,996332908859871104];
E_a = [283621.997064,152280.153710,185084.555527];
T1=398.662450000000;
M=120; % 电池质量g
Cp=1;% 比热容
numtimesteps = 20590;
Temp_0=T1;% 单位k
time = 1:numtimesteps;

% 定义目标函数，用于粒子群优化
objectiveFcn = @(p) sum((Copy_of_calculateValues(time, numtimesteps, A, E_a, Cp, M, Temp_0, T1, p(1), p(2), p(3)) - Temp).^2);

% 初始参数猜测，这需要你根据实际情况进行估计
Ub=double([420,460,510]);
Lb=double([398,420,460]);

% 粒子群优化参数
options = optimoptions('particleswarm', 'MaxIterations', 1000, 'Display', 'iter', 'SwarmSize', 30);

% 使用粒子群优化进行参数估计
[p, Fval] = particleswarm(objectiveFcn, 3,Lb,Ub,options);

% 调用 calculateValues 函数来计算温升数据
Temp_2 = Copy_of_calculateValues(time, numtimesteps, A, E_a, Cp, M, Temp_0, T1,p(1),p(2),p(3));
Temp_2=Temp_2(1:end);


figure
plot(time, Temp,'r', time,Temp_2(:,1),'b',LineWidth=2);
xlabel('时间 (秒)');
ylabel('温度 (K)');
title('温度随时间的变化');
grid on;

figure
plot(Temp, dTemp_dt,'r', Temp_2(:,1),Temp_2(:,2),'b',LineWidth=2);
xlabel('温度 (K)');
ylabel('温升速率 (K/s)');
title('温升随温度的变化');
grid on;