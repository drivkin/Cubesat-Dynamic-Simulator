%Setup of MOI tensors for 1 u cubesat with 3 reaction wheels with mass .1kg
%each and a .7kg uniform mass distribution box. The wheels have a radius of
%4.5cm and a thickness of 2mm, and are made of steel. The box is 9cm a
%side.

%location of overall center of mass wrt the center of mass of the cube
C = [.0046 .0046 .0046]';

%locations of the centers of mass of the wheels wrt the cube
w1 = [.046 0 0]';
w2 = [0 .046 0]';
w3 = [0 0 .046]';

w1c=w1-C;
w2c=w2-C;
w3c=w3-C;

%location of cm of the cube
cube = -C;

%.1(kg) is mass of each wheel, .7(kg) is mass of the cube
Isat = .1*(skew(w1c)'*skew(w1c)+skew(w2c)'*skew(w2c)+skew(w3c)'*skew(w3c))+.7*skew(cube)'*skew(cube);

%MOI tensor for satellite body (no wheels) WRT it's own center of mass in
%the body frame
Ibody = diag([9.45 9.45 9.45]*10^-4);

% Ibody = [9.45 10 10;
%         10 9.45 10;
%         10 10 9.45]*10^-4;
    
    % MOI tensor for reaction wheels about their own CM in reaction wheel coordinates
Iwheel = diag([5.07 5.07 10.1]*10^-5); %z is through the top, refer to http://en.wikipedia.org/wiki/List_of_moments_of_inertia#List_of_3D_inertia_tensors

%the wheels are aligned as follows: w1 z axis to body x axis, w2 z axis to
%body y axis, w3 z axis to body z axis. Right hand convention (curl fingers
%from x to y, thumb point to z) preserved

%transformation between w1 coordinates and body coordinates
Tb_w1 = [0 0 1; 
        1 0 0; 
        0 1 0];
    
Tb_w2 = [0 1 0; 
        0 0 1; 
        1 0 0];
    
Tb_w3 = eye(3);

% 3 by 3 by 3 matrix contating inertia tensors for the three wheels
% referred to the body frame
Iw_b = zeros(3,3,3);
Iw_b(:,:,1)=Tb_w1*Iwheel*Tb_w1';
Iw_b(:,:,2)=Tb_w2*Iwheel*Tb_w2';
Iw_b(:,:,3)=Tb_w3*Iwheel*Tb_w3';

sumMOI = sum(Iw_b,3)+Ibody+Isat;