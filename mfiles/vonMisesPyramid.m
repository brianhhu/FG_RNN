function [pyr1, msk1, pyr2, msk2] = vonMisesPyramid(map,vmPrs)
%Convolves input pyramid with von Mises distribution
%
%inputs:
%map - pyramid structure on which to apply von Mises filter
%vmPrs - parameters for von Mises filter
%
%outputs:
%pyr1 - filtered pyramid using msk1
%msk1 - first von mises mask at all scales and orientations
%pyr2 - filtered pyramid using msk2
%msk2 - second von mises mask at all scales and orientations
%
%by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012


for ori = 1:vmPrs.numOri
    for l = vmPrs.minLevel:vmPrs.maxLevel
        if ~(isempty(map(l)))
            
            pyr1(l).orientation(ori).data = imfilter(map(l).data,vmPrs.msk_1{ori});
            msk1(l).orientation(ori).data = vmPrs.msk_2{ori};
            pyr1(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            msk1(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            
            pyr2(l).orientation(ori).data = imfilter(map(l).data,vmPrs.msk_2{ori});
            msk2(l).orientation(ori).data = vmPrs.msk_1{ori};
            pyr2(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            msk2(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            
        else
            error('Map is empty at specifed level');
        end
    end
end
