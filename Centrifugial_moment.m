clc
clear
close all

%% Variables

l_humerus = 0.15;             % in m
l_ulna = 0.15;                % in m

diam_joint_1 = 0.007; % In m
radius_joint_1 = diam_joint_1/2;
diam_joint_2 = 0.007; % In m
radius_joint_2 = diam_joint_2/2;

m_humerus = 0.015;             % in Kg
m_ulna = 0.015;                % in Kg

flapping_freq = 8;         % Hz
Flapping_amp = 60;         % in deg

rot_freq = (2*Flapping_amp/360)*flapping_freq;
omega = 2*pi*rot_freq;

angle_base_second_bone = deg2rad(-20) % Angle of the base of the seconde parallel bone that couple the hum and ulna angle 

angle_body_hum = 0:pi/40:pi/2
angle_hum_ulna = -angle_body_hum + angle_base_second_bone;

%angle_body_hum = deg2rad(90);
%angle_hum_ulna = deg2rad(-135);


%% Positions

ulna_pos_x = round(l_humerus*cos(angle_body_hum), 5);
ulna_pos_y = round(l_humerus*sin(angle_body_hum), 5);

carp_pos_x = round(l_humerus*cos(angle_body_hum) + l_ulna*cos(angle_hum_ulna + angle_body_hum) , 2);
carp_pos_y = round(l_humerus*sin(angle_body_hum) + l_ulna*sin(angle_hum_ulna + angle_body_hum) , 2);

ulna_pos = [ulna_pos_x; ulna_pos_y];
carp_pos = [carp_pos_x; carp_pos_y];

half_hum = ulna_pos/2 
half_ulna = [((carp_pos_x + ulna_pos_x)/2); ((carp_pos_y + ulna_pos_y)/2)]

half_hum_dist = l_humerus/2
half_ulna_dist = l_ulna/2

dist_half_hum_origin = vecnorm(half_hum)
dist_half_ulna_origin = vecnorm(half_ulna)

%%

%{
for i = drange(1:size(angle_body_hum,2)) 
%for i = drange(1:2) 
    figure(i)
    %subplot(1, size(angle_body_hum,2),i)
    plot(0, 0,'g.');        % Body
    hold on
    plot(ulna_pos_x(i),ulna_pos_y(i),'r.');
    plot(carp_pos_x(i),carp_pos_y(i),'r.');
    plot(half_hum(1,i), half_hum(2,i),'k.');
    plot(half_ulna(1,i), half_ulna(2,i),'k.');
    plot([0 ulna_pos_x(i)],[0 ulna_pos_y(i)],'b',[ulna_pos_x(i) carp_pos_x(i)],[ulna_pos_y(i) carp_pos_y(i)],'b');
    title('angle = ', rad2deg(angle_body_hum(i)))
    hold off
end

%}

%% Compute F1 and F2

F1 = m_humerus * omega * omega * half_hum(1,:)  % In N

F2 =  m_ulna * omega * omega * half_ulna(1,:)  % In N

%% Compute the spring force needed

alpha = pi/2 + angle_base_second_bone;

M1 = half_hum_dist .* (F1.*cos(alpha))

M2 =  half_ulna_dist .* (F2.*cos(alpha))
F_2L = M2 ./ radius_joint_2
M1_2 = radius_joint_1 .* F_2L

M_tot = M1 + M1_2
M_spring = - M_tot

F_spring = abs(M_spring ./ radius_joint_1)

%% Plot

angle_body_hum_deg = rad2deg(angle_body_hum);

figure(12)
plot(angle_body_hum_deg, M_tot,'b-');        % Body
xlabel('Joint 1 angle in °')
ylabel('Joint Moment in N.m')
title('Moment of the centrifugial force on the first joint')

figure(13)
plot(angle_body_hum_deg, F_spring,'b-');
xlabel('Joint 1 angle in °')
ylabel('Spring force in N')
title('Spring force needed to compensate the centrifugial force')
%}
