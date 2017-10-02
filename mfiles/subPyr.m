function [pyr1, pyr2] = subPyr(pyr1,pyr2)
%Subtracts the levels of two input pyramids. It can handle the following pyramid
%structures pyr.data, pyr.orientation.data and pyr.hData/pyr.vData
%
%Inputs:
%
%   pyr1 - pyramid 1
%   pyr2 - pyramid 2
%
%Outputs;
%
%   pyr - pyramid 1 + pyramid 2
%
%By Brian Hu, Johns Hopkins University, 2017

if (nargin ~= 2)
    error('sumPyr needs two input arguments');
end
if isempty(pyr1)
    pyr = pyr2;
else
    if size(pyr1,2) ~= size(pyr2,2)
        error('Input pyramids different sizes');
    end
    if isfield(pyr1,'orientation')
        for l = 1:size(pyr1,2)
            for ori = 1:size(pyr1(l).orientation,2)
                pyr(l).orientation(ori).data = pyr1(l).orientation(ori).data+pyr2(l).orientation(ori).data;
                if isfield(pyr1(l).orientation,'ori')
                    pyr(l).orientation(ori).ori = pyr1(l).orientation(ori).ori;
                    if isfield(pyr1(l).orientation,'invmsk')
                        pyr(l).orientation(ori).invmsk = pyr1(l).orientation(ori).invmsk;
                    end
                end
                
            end
        end
    elseif isfield(pyr1,'data')
        for l = 1:size(pyr1,2)
            temp = pyr1(l).data-pyr2(l).data;
            pyr1(l).data = pyr1(l).data.*(temp>0); % rectify both pyramids
            pyr2(l).data = pyr2(l).data.*(temp<0);
        end
    elseif isfield(pyr1,'hData')
        for l = 1:size(pyr1,2)
            pyr(l).hData = pyr1(l).hData+pyr2(l).hData;
            pyr(l).vData = pyr1(l).vData+pyr2(l).vData;
        end
    end
end
