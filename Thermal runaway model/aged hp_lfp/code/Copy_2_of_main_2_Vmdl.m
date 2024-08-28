clc
clear

load Aged_82soh_HP_lfp_newdata.mat
Temp=new_data(:,1);
dTemp_dt=new_data(:,2);
% 设置参数
A = [262580508678629000000,660646.276052,24329431397060.3];
E_a = [177513.920079,74378.061747,146942.792239];
T1=365.35;
M=120; % 电池质量g
Cp=1;% 比热容
numtimesteps = 40042;
Temp_0=T1;% 单位k
time = 1:numtimesteps;

% 定义目标函数，用于粒子群优化
objectiveFcn = @(p) sum((Copy_of_calculateValues(time, numtimesteps, A, E_a, Cp, M, Temp_0, T1, p(1), p(2), p(3)) - Temp).^2);

% 初始参数猜测，这需要你根据实际情况进行估计
% initialGuess = double([385, 398, 480]); 
Ub=double([400,490,535]);
Lb=double([370,450,490]);

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

% 计算R-squared
SSres = sum((Temp_2 - Temp).^2);  % 残差平方和
SStot = sum((Temp_2 - mean(Temp)).^2);  % 总平方和
R2 = 1 - SSres/SStot;

% 计算MSE和RMSE
MSE = mean((Temp_2 - Temp).^2);
RMSE = sqrt(MSE);

% 计算MAE
MAE = mean(abs(Temp_2 - Temp));

% 计算MAPE
n = length(Temp_2); % 获取数据点的数量
mape = (100 / n) * sum(abs((Temp_2 - Temp) ./Temp));



% 显示精度指标
fprintf('R-squared: %f\n', R2);
fprintf('MSE: %f\n', MSE);
fprintf('RMSE: %f\n', RMSE);
fprintf('MAE: %f\n', MAE);
fprintf('MAPE: %f%%\n', mape);

% 绘制残差图
figure
residuals = Temp_2 - Temp;
plot(time, residuals, 'o');
xlabel('1/T');
ylabel('Residuals');
title('Residual Plot');