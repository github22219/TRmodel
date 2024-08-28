clc
clear
load HP_lfp_newdata.mat
Temp=new_data(:,1);
dTemp_dt=new_data(:,2);
numtimesteps=size(new_data);


Temp=double(Temp(1850:6949));
dTemp_dt=double(dTemp_dt(1850:6949));

% 设计巴特沃斯低通滤波器
Fs = 1000; % 采样频率，示例中为1000 Hz
Wn = 2*30/Fs; % 截止频率为50 Hz，根据信号特性确定
[b,a] = butter(7, Wn); % 计算滤波器系数，滤波器的阶数为4

% 对信号进行滤波
dTemp_dt_filtered = filter(b, a, dTemp_dt);

% 假设 Te_2, T0, Temp, dTemp_dt 是已知的实验数据
Te_2 = 410.2; % 假设的 Te_2 值
T0 = 398;    % 假设的 T0 值
Te_2=double(Te_2);
T0 = double(T0); 
% 定义目标函数，用于最小二乘法
%Function = @(p, Temp) log(p(1)) + p(2)/(8.314*Temp) - log(dTemp_dt/(Te_2 - T0));
Function = @(p, Temp) p(1).* (Te_2 - Temp) .* exp(p(2)./(-8.314.*Temp));

% 其中 p(1) 对应于 A_2，p(2) 对应于 Ea_2
% Temp 是温度数据，dTemp_dt 是随时间变化的温度数据，Te_2 和 T0 是常数



% 初始参数猜测，这需要你根据实际情况进行估计
initialGuess = double([1*10^11, 140000]); % 例如，[A_2的估计值), Ea_2的估计值]
Ub=double([1*10^15,2*10^5]);
Lb=double([1*10^5,0.2*10^4]);

% 使用 lsqcurvefit 进行参数估计
options = optimoptions('lsqcurvefit', 'Display', 'iter', 'MaxFunEvals', 1000);
[p, resnorm] = lsqcurvefit(Function, initialGuess, Temp, dTemp_dt_filtered, Lb, Ub, options);

% 从估计的参数中获取 A_2 和 Ea_2
A_2 = p(1);
Ea_2 = p(2);

% 显示结果
fprintf('A_2 = %f\n', A_2);
fprintf('Ea_2 = %f\n', Ea_2);

% 计算目标函数的残差范数
fprintf('Residual norm: %f\n', resnorm);

R=log(dTemp_dt_filtered./(Te_2-Temp));
R_SIM=log(A_2) - Ea_2./(8.314.*Temp);
x=1./Temp;
plot(x,R,x,R_SIM,LineWidth=3);
xlabel('1/T');
ylabel('lnR*');