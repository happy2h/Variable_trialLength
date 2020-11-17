% 参数设定
clear all;
A = [1 0;0 1];
A1 = [0 1;-2 3];
B = [1;2];
C = [0.2 0.3];
D = 1;
% DMDEF 函数设定
time = -5:1:20;
tl = length(time);
% 期望轨迹设定
for t = 1:tl
    if time(t) >= 0
        yd(t) = 2*t*sin(4*t);
    end
end
figure(1);
plot(time,yd,'linewidth',2);hold on;
% 迭代学习过程
iter_n = 50; % 迭代次数
% 对每次迭代过程k，先产生一个随机结束的实验长度在[17 22]之中
e(:,1:tl) = 0;
for k = 1:1:iter_n
    t_end(k) = 16 + randperm(6,1);
    if t_end(k) >= time(tl)
        for t = 1:1:tl
            if k == 1
                u(k,t) = 0;
            else
                u(k,t) = u(k-1,t) + 0.5*e(k-1,t);
            end
            if time(t) >= -5 && time(t) <= 0
                x(:,:,k,t) = [2;1];
            elseif time(t) > 0
                x(:,:,k,t) = A*x(:,:,k,t-1) + A1*x(:,:,k,t-5) + B*u(k,t);
            end
            y(k,t) = C*x(:,:,k,t) + D*u(k,t);
            e(k,t) = yd(t) - y(k,t);
        end
    elseif t_end(k) < time(tl)
        for t = 1:1:t_end(k)
            if k == 1
                u(k,t) = 0;
            else
                u(k,t) = u(k-1,t) + 0.5*e(k-1,t);
            end
            if time(t) >= -5 && time(t) <= 0
                x(:,:,k,t) = [2;1];
            elseif time(t) > 0
                x(:,:,k,t) = A*x(:,:,k,t-1) + A1*x(:,:,k,t-5) + B*u(k,t);
            end
            y(k,t) = C*x(:,:,k,t) + D*u(k,t);
            e(k,t) = yd(t) - y(k,t);
        end
        for t = (t_end(k)+1):1:tl
            if k == 1
                u(k,t) = 0;
            else
                u(k,t) = u(k-1,t) + 0.5*e(k-1,t);
            end
            x(:,:,k,t) = A*x(:,:,k,t-1) + A1*x(:,:,k,t-5) + B*u(k,t);
            y(k,t) = C*x(:,:,k,t) + D*u(k,t);
            e(k,t) = 0;
        end
    end
end
plot(time,y(10,:),'*-');
plot(time,y(20,:),'o-');
plot(time,y(50,:),'*');

