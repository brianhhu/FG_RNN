function [gPyr1, gPyr2, bPyr1_1, bPyr1_2, bPyr2_1, bPyr2_2, cPyr] = makeGrouping(bPyr1_1,bPyr1_2,bPyr2_1,bPyr2_2,cPyr,params)
%Computed grouping activity from the border ownership pyramids
%
%Inputs:
%b1Pyr - Border Ownership pyramid 1
%b2Pyr - Border Ownership pyramid 2
%params - model parameter structure
%
%Outputs: 
%gPyr - grouping pyramid
%b1Pyr - Border Ownership pyramid 1
%b2Pyr - Border Ownership pyramid 2
%cPyr  - Complex edge cell pyramid
%
%Original by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
%Modified by Brian Hu, Johns Hopkins University, 2017

for m = 1:size(bPyr1_1,2)
    fprintf('\nAssigning Grouping on ');
    fprintf(bPyr1_1{m}.type);
    fprintf(' channel:\n');    
    for sub = 1:size(bPyr1_1{m}.subtype,2)
        fprintf('Subtype %d of %d : ',sub,size(bPyr1_1{m}.subtype,2));
        fprintf(bPyr1_1{m}.subname{sub});
        fprintf('\n');

        % Feedforward grouping
        [gPyr1_1{m}.subtype{sub}, gPyr1_2{m}.subtype{sub}, gPyr2_1{m}.subtype{sub}, gPyr2_2{m}.subtype{sub}] = grouping_feedforward(bPyr1_1{m}.subtype{sub},bPyr1_2{m}.subtype{sub},bPyr2_1{m}.subtype{sub},bPyr2_2{m}.subtype{sub},params);
        
        % Combine th different orientations into one map
        g11 = mergeLevel(gPyr1_1{m}.subtype{sub}); % light on dark
        g12 = mergeLevel(gPyr1_2{m}.subtype{sub});
        gPyr1{m}.subtype{sub} = sumPyr(g11,g12);  

        g21 = mergeLevel(gPyr2_1{m}.subtype{sub}); % dark on light
        g22 = mergeLevel(gPyr2_2{m}.subtype{sub});
        gPyr2{m}.subtype{sub} = sumPyr(g21,g22);  
        
        
        % Subtract these two g_maps from each other (inhibition between different polarity g-cells)
        [gPyr1{m}.subtype{sub}, gPyr2{m}.subtype{sub}] = subPyr(gPyr1{m}.subtype{sub},gPyr2{m}.subtype{sub});

        % Grouping feedback to border ownership cells
        [bPyr1_1{m}.subtype{sub}, bPyr1_2{m}.subtype{sub}, bPyr2_1{m}.subtype{sub}, bPyr2_2{m}.subtype{sub}, cPyr{m}.subtype{sub}] = grouping_feedback(gPyr1{m}.subtype{sub},gPyr2{m}.subtype{sub},bPyr1_1{m}.subtype{sub},bPyr1_2{m}.subtype{sub},bPyr2_1{m}.subtype{sub},bPyr2_2{m}.subtype{sub},cPyr{m}.subtype{sub},params);        

    end

    gPyr1{m}.type = bPyr1_1{m}.type;
    gPyr2{m}.type = bPyr1_1{m}.type;
    
end
