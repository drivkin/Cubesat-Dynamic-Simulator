function LExt = compute_LExt_init(wIF,attIF,wM,IWheels,ISat)
%Given initial speed, orientation, wheel speed, and moments, compute the
%external moment of inertia (moment due to external forces) of the system
%at t=0;

%generate reaction wheel angular momentum vector
LWheels = IWheels .* wM;
%convert to inertial frame
LWheelsIF = quatrotate(attIF,LWheels)

netMoment = wIF.*quatrotate(attIF,ISat)

LExt = netMoment + LWheelsIF;


end

