function [sumQ, Q_m, Q, dTemp_dt, Temp] = calculateValues(numtimesteps, A, E_a, Cp, M, Temp_0, T1,Tv,T2,T_260)
    % 初始化变量
    Q_m = zeros(numtimesteps, 1);
    Q_m_1 = zeros(numtimesteps, 1);
    Q_m_2 = zeros(numtimesteps, 1);
    Q_m_3 = zeros(numtimesteps, 1);
    Q = zeros(numtimesteps, 1);
    dTemp_dt = zeros(numtimesteps, 1);
    Temp = Temp_0*ones(numtimesteps, 1); % 使用零向量初始化 Temp
    Q_ele = zeros(numtimesteps,1);
    sumQ=0;
    % 遍历时间步
    for i = 1:numtimesteps
        if Tv > Temp(i) && Temp(i) >= T1
            Q_m_1(i) = A(1) * (Tv-Temp(i)) * exp(-E_a(1) ./ (8.314 * Temp(i)))*Cp*M; 
            Q_m_2(i) = A(2) * (T_260-Temp(i)) * exp(-E_a(2) ./ (8.314 * Temp(i)))*Cp*M;
            Q_m_3(i) = A(3) * (T_260-Temp(i)) * exp(-E_a(3) ./ (8.314 * Temp(i)))*Cp*M;
            % 计算温度变化率
            Q_m(i)=Q_m_1(i)+Q_m_2(i)+Q_m_3(i);
            dTemp_dt(i) = Q_m(i) / (M * Cp);
        % 温度范围在 393-443K 之间的情况
        elseif T2 > Temp(i) && Temp(i) >= Tv
            Q_m_2(i) = A(2) * (T_260-Temp(i)) * exp(-E_a(2) ./ (8.314 * Temp(i)))*Cp*M;
            Q_m_3(i) = A(3) * (T_260-Temp(i)) * exp(-E_a(3) ./ (8.314 * Temp(i)))*Cp*M;  
            % 计算温度变化率
            Q_m(i)=Q_m_2(i)+Q_m_3(i);
            dTemp_dt(i) = Q_m(i) / (M * Cp);
        elseif T_260 > Temp(i) && Temp(i) >= T2
            Q_m_3(i) = A(3) * (T_260-Temp(i)) * exp(-E_a(3) ./ (8.314 * Temp(i)))*Cp*M;
            Q_m(i)=Q_m_3(i);
            dTemp_dt(i) = Q_m(i) / (M * Cp);
        % 温度范围在大于533k的情况
        elseif Temp(i) >=T_260 
            delta_t = 8;
            % delta_He(100%SOC
            % 10ah软包电池，标称电压3.2V)，故为9.5ah*3600s*3.65V=124830J
            Q_ele(i+1) = (116195 - sum(Q_ele(1:i))) / delta_t;
            % 计算总产热功率
            Q(i) = Q_m(i) + Q_ele(i+1);            % 计算温度变化率
            dTemp_dt(i) = Q(i) / (M * Cp);
        end
        % 更新温度
        sumQ=sumQ+Q_m(i);
        Temp(i+1) = Temp_0 + sum(dTemp_dt(1:i));
    end

