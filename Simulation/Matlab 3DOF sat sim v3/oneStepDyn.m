function [Tb_i wb_i ab_i] = oneStepDyn(Tsample,sumMOI, Iw_b,ww_b,aw_b, Tb_i,wb_i,mb);
% Compute one step of the satellite dynamics
%
%Tsample: sample time

%sumMOI: The sum of all of the MOI matrices 

%Isat: MOI tensor wrt. overall CM for whole satellite (wheels and all) in
%body coordinates

%Ibody: MOI tensor of satellite body (w/o wheels) wrt. its cm in body
%coordinates

%Iw_b: 3 MOI tensors, one for each wheel wrt it's center of mass, expressed
%in body coordinates

%ww_b: 3 angular velocity vectors, one for each wheel wrt. the body,
%expressed in body coordinates

%aw_b: 3 angular acceleration vectors, one for each wheel wrt. the body,
%expressed in body coordinates

%Tb_i: the direction cosine matrix expressing the transformation from
%inertial coordinates to body coordinates

%wb_i: the angular velocity of the body frame wrt. the inertial frame,
%expressed in body coordinates

%ab_i: angular acceleration of body frame wrt. the inertial frame expressed
%in body coordinates

%mb: external torques about the overall C.M., expressed in body coordinates




term1 = Iw_b(:,:,1)*aw_b(:,1)+Iw_b(:,:,2)*aw_b(:,2)+Iw_b(:,:,3)*aw_b(:,3);

term2 = skew(wb_i)*(Iw_b(:,:,1)*ww_b(:,1)+Iw_b(:,:,2)*ww_b(:,2)+Iw_b(:,:,3)*ww_b(:,3));

term3 = skew(wb_i)*sumMOI*wb_i;

rhs = mb - term1 - term2 - term3;


ab_i = inv(sumMOI)*rhs;

wb_i = wb_i+ab_i*Tsample;

Tb_i = Tb_i+Tsample*((skew(wb_i))'*Tb_i);

for i=1:1
Tb_i = orthogonalize(Tb_i);
end







end

