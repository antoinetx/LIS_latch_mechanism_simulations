clc
clear
close all

%% Variables

l_humerus = 150;               % in mm
l_ulna = 150;                  % in mm

sma_len = l_humerus + l_ulna % in mm

m_humerus = 0.015;             % in Kg
m_ulna = 0.015;                % in Kg

%diam_joint_hum = 4;            % in mm
%diam_joint_ulna = 4;           % in mm

diam_joint_hum = 1:1:15;
diam_joint_ulna = diam_joint_hum;

angle_secondary_bone = deg2rad(-45) % the secondary bone have the same lenght
angle_body_hum = deg2rad(45)
angle_hum_ulna = angle_body_hum + pi/2 + angle_secondary_bone

%test = rad2deg(angle_hum_ulna)     % Angle ulna in deg


%% Positions

ulna_pos_x = round(l_humerus*cos(angle_body_hum), 2);
ulna_pos_y = round(l_humerus*sin(angle_body_hum), 2);

carp_pos_x = round(l_humerus*cos(angle_body_hum) + l_ulna*cos(angle_hum_ulna + angle_body_hum) , 2);
carp_pos_y = round(l_humerus*sin(angle_body_hum) + l_ulna*sin(angle_hum_ulna + angle_body_hum) , 2);

ulna_pos = [ulna_pos_x, ulna_pos_y];
hum_pos = [carp_pos_x, carp_pos_y];


%% plot

%{
plot(0, 0,'g.');        % Body
hold on
plot(ulna_pos_x,ulna_pos_y,'r.');
plot(carp_pos_x,carp_pos_y,'r.');
plot([0 ulna_pos_x],[0 ulna_pos_y],'b',[ulna_pos_x carp_pos_x],[ulna_pos_y carp_pos_y],'b');
hold off
%}

%% Lenght

if angle_hum_ulna ~= 0
    pourcentage_ulna = abs(angle_hum_ulna/(2*pi))
else
    pourcentage_ulna = 0
end

if angle_body_hum ~= 0
    pourcentage_hum = abs(angle_body_hum/(2*pi))
else
    pourcentage_hum = 0
end

cord_lenght_open_wing = sqrt(l_humerus^2 + (diam_joint_hum./2 + diam_joint_ulna./2).^2) + sqrt(l_ulna^2 + (diam_joint_ulna./2).^2)
cord_lenght_close_wing = sqrt(l_humerus^2 + (diam_joint_hum./2 + diam_joint_ulna./2).^2) + sqrt(l_ulna^2 + (diam_joint_ulna./2).^2) + (2*pi*diam_joint_ulna./2).*pourcentage_ulna + (2*pi*diam_joint_hum./2).*pourcentage_hum % when the hulm and ulna angles are equal to 90 and - 180.

required_lenght_to_open_the_wing = cord_lenght_close_wing - cord_lenght_open_wing

%% Plot 

figure(2)
plot(diam_joint_hum,required_lenght_to_open_the_wing,'b-');
yline(0.03*sma_len)
yline(0.05*sma_len)
xlabel('Joint diameter in mm')
ylabel('rode lenght in mm')
title('Required rope lenght to extend the wing')




%% Joints diamater needed for a desired cord extension

%max_cord_extension = 9 % in mm


