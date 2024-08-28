clc
clear
load shangyong_lfp_newdata.mat
Temp=new_data(:,1);
dTemp_dt=new_data(:,2);
numtimesteps=size(new_data);


Temp=double(Temp(1:23927));
dTemp_dt=double(dTemp_dt(1:23927));

% 设计巴特沃斯低通滤波器
Fs = 50000; % 采样频率，示例中为1000 Hz
Wn = 2*100/Fs; % 截止频率为50 Hz，根据信号特性确定
[b,a] = butter(1, Wn); % 计算滤波器系数，滤波器的阶数为4

% 对信号进行滤波
dTemp_dt_filtered = filter(b, a, dTemp_dt);

% 假设 Te_2, T0, Temp, dTemp_dt 是已知的实验数据
Te_2 = 387.12; % 假设的 Te_2 值
Te_2=double(Te_2);
% 定义目标函数，用于最小二乘法
% ... [其他代码不变] ...

% 对数变换
ln_dTemp_dt = log(dTemp_dt_filtered./(Te_2-Temp));

% 使用线性回归拟合 1/T 和 ln(dT/dt)
p_linear = polyfit(1./Temp, ln_dTemp_dt, 1);

% 从线性回归中获取参数
slope = p_linear(1); % 对应于 Ea_2 / (-8.314)
intercept = p_linear(2); % 对应于 log(A_2)

% 显示结果
fprintf('Slope (Ea_2 / (-8.314)) = %f\n', slope);
fprintf('Intercept (log(A_2)) = %f\n', intercept);

Ea_2=slope*(-8.314);
A_2=exp(intercept);

% 显示结果
fprintf('Ea_2 = %f\n', Ea_2);
fprintf('A_2 = %f\n', A_2);


% 绘制原始数据和线性拟合结果
x = 1./Temp;
R_SIM=intercept + slope*x;
figure
plot(x, ln_dTemp_dt, 'b.', x, R_SIM, 'r-', 'LineWidth', 3);
xlabel('1/T');
ylabel('ln(dT/dt)');
legend('Experimental', 'Linear Fit');

% 计算R-squared
SSres = sum((ln_dTemp_dt - R_SIM).^2);  % 残差平方和
SStot = sum((ln_dTemp_dt - mean(ln_dTemp_dt)).^2);  % 总平方和
R2 = 1 - SSres/SStot;

% 计算MSE和RMSE
MSE = mean((ln_dTemp_dt - R_SIM).^2);
RMSE = sqrt(MSE);

% 计算MAE
MAE = mean(abs(ln_dTemp_dt - R_SIM));

% 计算MAPE
n = length(ln_dTemp_dt); % 获取数据点的数量
mape = (100 / n) * sum(abs((ln_dTemp_dt - R_SIM) ./ ln_dTemp_dt));



% 显示精度指标
fprintf('R-squared: %f\n', R2);
fprintf('MSE: %f\n', MSE);
fprintf('RMSE: %f\n', RMSE);
fprintf('MAE: %f\n', MAE);
fprintf('MAPE: %f%%\n', mape);

% 绘制残差图
figure
residuals = ln_dTemp_dt - R_SIM;
plot(1./Temp, residuals, 'o');
xlabel('1/T');
ylabel('Residuals');
title('Residual Plot');