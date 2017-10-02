function params = makeDefaultParams()
%Sets the default parameters for the grouping model
%
%inputs: none
%
%Outputs:
%params - parameter structure for grouping model
%
%Original by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
%Modified by Brian Hu, Johns Hopkins University, 2017

%pyramid levels over which to compute
minLevel = 1;  %leave as 1
maxLevel = 10; %How many times do you want to downsample the pyramid

%number of iterations to run the model for
params.iterations = 10;

%intensity and color channel weights (80% intensity, 20% color)
params.gray = 0.8;
params.color = 0.2;

%set downsampling mode
params.downSample = 'half'; %downsample by 'half' or 'full' octave. better performance at half

%feature channels on which to operate
params.channels = 'IC'; %intensity and color
% params.channels = 'I'; %intensity only
                           %I - intensity
                           %C - color opponency

params.maxLevel = maxLevel;

%ENTER EDGE MAP ORIENTATIONS (DEG) FOR 1ST QUADRANT ONLY INTO ORI
%   - computations are done on ori and ori + 90 degrees
ori = [0 22.5 45 67.5]; % 8 orientations
oris = deg2rad([ori (ori+90)]);

%grouping cell radius
R0 = 2; % manually set radius here
fprintf('\nCenter Surround Radius is %d pixels. \n',R0);

%border pyramid paramers
params.bPrs.minLevel = minLevel;
params.bPrs.maxLevel = maxLevel;
params.bPrs.numOri = length(oris);
params.bPrs.alpha = 2; % original = 1
params.bPrs.oris = oris;
params.bPrs.CSw = 1; %inhibition between CS pyramids

%von Mises distribution parameters
params.vmPrs.minLevel = minLevel;
params.vmPrs.maxLevel = maxLevel;
params.vmPrs.oris = oris;
params.vmPrs.numOri = length(oris);
params.vmPrs.R0 =R0;

%ADDED: make von Mises masks here (reused many times in code, so just do it once here)
vmPrs = params.vmPrs;
dim1 = -3*vmPrs.R0:3*vmPrs.R0;
dim2 = dim1;
for i = 1:vmPrs.numOri
    [params.vmPrs.msk_1{i}, params.vmPrs.msk_2{i}] = makeVonMises(vmPrs.R0,vmPrs.oris(i)+pi/2,dim1,dim2);
end

%grouping cell inhibition parameters
params.giPrs.w_sameChannel = 1;% Inhibitory weight for same channel inhibition

