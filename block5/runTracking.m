param = getDefaultParameters();  % get parameters that work well

%Filter parameters
param.motionModel = 'ConstantVelocity'; 
param.initialEstimateError = param.initialEstimateError(1:2);
param.motionNoise          = param.motionNoise(1:2);

%Other
param.sequence = 'highway.avi';  %EX: 'singleball.avi', 'traffic.avi', 'highway.avi'
param.label = 'Car';
trackSingleObject(param); % visualize the results