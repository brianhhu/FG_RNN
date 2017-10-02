function [bPyr1_1, bPyr1_2, bPyr2_1, bPyr2_2, cPyr]  = makeBorderOwnership(img,params)
%Creates border ownership cells for the input image im
%
%Inputs:
%   img    - image structure on which to perform grouping and border ownership
%   params - parameter structure for the model
%
%Outputs:
%   bPyr1_1, bPyr1_2 - Border ownership activity (left and right) for light on dark objects
%   bPyr2_1, bPyr2_2 - Border ownership activity (left and right) for dark on light objects
%   cPyr             - Bottom-up edges detected using CORF operator
%
%Original by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
%Modified by Brian Hu, Johns Hopkins University, 2017


%% EXTRACT EDGES
for m = 1:size(img,2)
    fprintf('\nAssigning Border Ownership on ');
    fprintf(img{m}.type);    
    fprintf(' channel:\n');    
    for sub = 1:size(img{m}.subtype,2)        
        fprintf('Subtype %d of %d : ',sub,size(img{m}.subtype,2));
        map = img{m}.subtype{sub}.data;                       
        imPyr = makePyramid(map,params);

        %% -----------------Edge Detection ------------------------------------
        for l=1:params.maxLevel

            % Parameters based on the original CORF model
            [~,~,o_val,o_ind] = CORFContourDetection(imPyr(l).data,2.2,4,1.8);

            for ori=1:params.bPrs.numOri

                ori_index = mod(round(o_ind/(2*pi)*16)+4,16)+1; % easier to work with integers, and circ_shifted
  
                cPyr{m}.subtype{sub}(l).orientation(ori).data = o_val.*(ori_index==ori);
                cPyr{m}.subtype{sub}(l).orientation(ori+8).data = o_val.*(ori_index==ori+8);

                % light object on dark background (similar for color channel)
                bPyr1_1{m}.subtype{sub}(l).orientation(ori).data = cPyr{m}.subtype{sub}(l).orientation(ori).data;
                bPyr1_2{m}.subtype{sub}(l).orientation(ori).data = cPyr{m}.subtype{sub}(l).orientation(ori+8).data;
                bPyr1_1{m}.subtype{sub}(l).orientation(ori).invmsk = params.vmPrs.msk_2{ori};
                bPyr1_2{m}.subtype{sub}(l).orientation(ori).invmsk = params.vmPrs.msk_1{ori};
                
                % dark object on light background (similar for color channel)
                bPyr2_1{m}.subtype{sub}(l).orientation(ori).data = cPyr{m}.subtype{sub}(l).orientation(ori+8).data;
                bPyr2_2{m}.subtype{sub}(l).orientation(ori).data = cPyr{m}.subtype{sub}(l).orientation(ori).data; % note this is reversed compared to above
                bPyr2_1{m}.subtype{sub}(l).orientation(ori).invmsk = params.vmPrs.msk_2{ori};
                bPyr2_2{m}.subtype{sub}(l).orientation(ori).invmsk = params.vmPrs.msk_1{ori};
            end
        end
        
        bPyr1_1{m}.subname{sub} = img{m}.subtype{sub}.type;
        bPyr1_2{m}.subname{sub} = img{m}.subtype{sub}.type;
        bPyr2_1{m}.subname{sub} = img{m}.subtype{sub}.type;
        bPyr2_2{m}.subname{sub} = img{m}.subtype{sub}.type;
        
    end
    
    bPyr1_1{m}.type = img{m}.type;
    bPyr1_2{m}.type = img{m}.type;
    bPyr2_1{m}.type = img{m}.type;
    bPyr2_2{m}.type = img{m}.type;
    
end



