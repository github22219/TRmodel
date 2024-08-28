function Temp_ident = Copy_of_calculateValues(time, numtimesteps, A, E_a, Cp, M, Temp_0, T1,Tv,T2,T_260)
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
    for i = time
        if Tv > Temp(i) && Temp(i) >= T1
            Q_m_1(i) = A(1) * (411.65-Temp(i)) * exp(-E_a(1) ./ (8.314 * Temp(i)))*Cp*M; 
            % 计算温度变化率
            Q_m(i)=Q_m_1(i);
            dTemp_dt(i) = Q_m(i) / (M * Cp);
        elseif T2 > Temp(i) && Temp(i) >= Tv
            if Temp(i)<=411.65
            Q_m_1(i) = A(1) * (411.65-Temp(i)) * exp(-E_a(1) ./ (8.314 * Temp(i)))*Cp*M;
            Q_m_2(i) = A(2) * (448-Temp(i)) * exp(-E_a(2) ./ (8.314 * Temp(i)))*Cp*M;
            else
            Q_m_2(i) = A(2) * (448-Temp(i)) * exp(-E_a(2) ./ (8.314 * Temp(i)))*Cp*M;
            end
            % 计算温度变化率
            Q_m(i)=Q_m_1(i)+Q_m_2(i);
            dTemp_dt(i) = Q_m(i) / (M * Cp);
        elseif T_260 > Temp(i) && Temp(i) >= T2
           if Temp(i)<=448
           Q_m_2(i) = A(2) * (445-Temp(i)) * exp(-E_a(2) ./ (8.314 * Temp(i)))*Cp*M;
           Q_m_3(i) = A(3) * (496.3-Temp(i)) * exp(-E_a(3) ./ (8.314 * Temp(i)))*Cp*M;
           else
           Q_m_3(i) = A(3) * (496.3-Temp(i)) * exp(-E_a(3) ./ (8.314 * Temp(i)))*Cp*M;
           end
           % 计算温度变化率
           Q_m(i)=Q_m_2(i)+Q_m_3(i);
           dTemp_dt(i) = Q_m(i) / (M * Cp);
        elseif Temp(i) >=T_260 
            delta_t = 10;
            % delta_He(100%SOC
            % 10ah软包电池，标称电压3.2V)，故为9.5ah*3600s*3.2V=109440J
            Q_ele(i+1) = (15000 - sum(Q_ele(1:i))) / delta_t;
            % 计算总产热功率
            Q(i) = Q_m(i) + Q_ele(i+1);            % 计算温度变化率
            dTemp_dt(i) = Q(i) / (M * Cp);
        end
        % 更新温度
        sumQ=sumQ+Q_m(i);
        Temp(i+1) = Temp_0 + sum(dTemp_dt(1:i));
        Temp_ident=Temp(1:end-1);
    end

