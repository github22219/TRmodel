clc
clear

load shangyong_lfp_newdata.mat
Temp=new_data(:,1);
dTemp_dt=new_data(:,2);
% 设置参数
A = [101734500233.7, 94656389352.8,5742516.826203];
E_a = [108994.2,110673.0,86976.374517];
T1=359.1502112;
M=120; % 电池质量g
Cp=1;% 比热容
numtimesteps = 45629;
Temp_0=T1;% 单位k
time = 1:numtimesteps;

% 定义目标函数，用于最小二乘法
Function = @(p, time) Copy_of_calculateValues(time, numtimesteps, A, E_a, Cp, M, Temp_0, T1,p(1),p(2),p(3));

% 生成时间数据（假设每个时间步长为1秒）


% 初始参数猜测，这需要你根据实际情况进行估计
initialGuess = double([385, 395, 460]); 
Ub=double([450,450,500]);
Lb=double([359,359,359]);

% 使用 lsqcurvefit 进行参数估计
options = optimoptions('lsqcurvefit', 'Display', 'iter', 'MaxFunEvals', 1000);
[p, resnorm] = lsqcurvefit(Function, initialGuess, time, Temp, Lb, Ub, options);


% 调用 calculateValues 函数来计算温升数据
Temp_2 = Copy_of_calculateValues(time, numtimesteps, A, E_a, Cp, M, Temp_0, T1,p(1),p(2),p(3));
Temp_2=Temp_2(1:end);


figure
plot(time, Temp, time,Temp_2);
xlabel('时间 (秒)');
ylabel('温度 (K)');
title('温升随温度的变化');
grid on;

