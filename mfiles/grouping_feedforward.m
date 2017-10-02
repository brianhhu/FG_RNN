function [gPyr1_1, gPyr1_2, gPyr2_1, gPyr2_2] = grouping_feedforward(bPyr1_1,bPyr1_2,bPyr2_1,bPyr2_2,params)
%Calculates grouping activity from border ownership activity
%
%Inputs:
%bPyr1 - border ownership pyramid 1 from von Mises Msk1
%bPyr2 - border ownership pyramid 2 from von Mises Msk2
%params - parameter structure
%
%Outputs:
%gPyr1 - grouping pyramid constructed from von Mises Msk1
%gPyr2 - grouping pyramid constructed from von Mises Msk2
%
%Original by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2011
%Modified by Brian Hu, Johns Hopkins University, 2017

%weight parameters
bPrs = params.bPrs;
giPrs = params.giPrs;
w = giPrs.w_sameChannel;

%calculate grouping neuron responses
for l = bPrs.minLevel:bPrs.maxLevel
    
    for ori = 1:bPrs.numOri
        
        invmsk1 = bPyr1_1(l).orientation(ori).invmsk;
        invmsk2 = bPyr1_2(l).orientation(ori).invmsk;
        
        if isequal(bPyr1_1(l).orientation(ori).data, bPyr2_2(l).orientation(ori).data) % don't use inhibition on the first iteration
            gPyr1_1(l).orientation(ori).data = imfilter(bPyr1_1(l).orientation(ori).data,invmsk1);
            gPyr1_2(l).orientation(ori).data = imfilter(bPyr1_2(l).orientation(ori).data,invmsk2);
            gPyr2_1(l).orientation(ori).data = imfilter(bPyr2_1(l).orientation(ori).data,invmsk1);
            gPyr2_2(l).orientation(ori).data = imfilter(bPyr2_2(l).orientation(ori).data,invmsk2);
        else
            % opposite border-ownership cells inhibit each other
            gPyr1_1(l).orientation(ori).data = imfilter(bPyr1_1(l).orientation(ori).data-w.*bPyr2_2(l).orientation(ori).data,invmsk1);
            gPyr1_2(l).orientation(ori).data = imfilter(bPyr1_2(l).orientation(ori).data-w.*bPyr2_1(l).orientation(ori).data,invmsk2);
            gPyr2_1(l).orientation(ori).data = imfilter(bPyr2_1(l).orientation(ori).data-w.*bPyr1_2(l).orientation(ori).data,invmsk1);
            gPyr2_2(l).orientation(ori).data = imfilter(bPyr2_2(l).orientation(ori).data-w.*bPyr1_1(l).orientation(ori).data,invmsk2);
        end
    end
end

