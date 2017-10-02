function pyr = makePyramid(img,params)
%Makes the centre surround pyramid using a CS mask on each
%layer of the image pyramid
%
%inputs :
%img - input image
%params - model parameter structure
%
%outputs :
%pyr - image pyramid
%
%Original by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
%Modified by Brian Hu, Johns Hopkins University, 2017

if (nargin ~= 2)
    error('Incorrect number of inputs for makePyramid');
end
if (nargout ~= 1)
    error('One output argument required for makePyramid');
end

depth = params.maxLevel;

pyr(1).data = img;
for l = 2:depth
    if strcmp(params.downSample,'half')%downsample halfoctave
        pyr(l).data = imresize(pyr(1).data,1/(sqrt(2)^(l-1)),'cubic'); % use starting image instead of previous layer
    elseif strcmp(params.downSample,'full') %downsample full octave
        pyr(l).data = imresize(pyr(1).data,1/(2^(l-1)),'cubic');
    else
        error('Please specify if downsampling should be half or full octave');
    end
end
