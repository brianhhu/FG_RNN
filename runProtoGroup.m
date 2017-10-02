function [edge_map, occ_map, group_map] = runProtoGroup(filename) 
%Runs the proto-object based grouping model for computation of border-ownership and grouping responses
%
%inputs:
%filename - filename of image
%
%By Brian Hu, Johns Hopkins University, 2017

% make sure all files are on the path
addpath(genpath(pwd));

fprintf('Start Proto-Object Grouping')

% generate parameter structure
params = makeDefaultParams;

% load and normalize image
im = im2double(imread(filename));


% % solid square
% im = zeros(257,257);
% im(129-64:129+64,129-64:129+64) = 1; %128 square
% im = repmat(im, [1 1 3]);

% % proximity
% im = zeros(257,257);
% im(129-16:129+16,[129-80 129-64 129-32 129-16 129+16 129+32 129+64 129+80]) = 1;
% im = repmat(im, [1 1 3]);


% generate feature channels
img = generateChannels(im,params);

% generate border ownership structures
[bPyr1_1, bPyr1_2, bPyr2_1, bPyr2_2, cPyr] = makeBorderOwnership(img,params);


% if using color information
if strcmp(params.channels,'IC')

    % temporarily store BOS pyramids
    btemp1 = bPyr1_1{2};
    btemp2 = bPyr1_2{2};
    
    % combine R-G channels
    bPyr1_1{2}.subtype{1} = sumPyr(btemp1.subtype{1},btemp2.subtype{2});
    bPyr1_2{2}.subtype{1} = sumPyr(btemp2.subtype{1},btemp1.subtype{2});
    bPyr2_1{2}.subtype{1} = bPyr1_2{2}.subtype{1};
    bPyr2_2{2}.subtype{1} = bPyr1_1{2}.subtype{1};
    
    % combine B-Y channels
    bPyr1_1{2}.subtype{3} = sumPyr(btemp1.subtype{3},btemp2.subtype{4});
    bPyr1_2{2}.subtype{3} = sumPyr(btemp2.subtype{3},btemp1.subtype{4});
    bPyr2_1{2}.subtype{3} = bPyr1_2{2}.subtype{3};
    bPyr2_2{2}.subtype{3} = bPyr1_1{2}.subtype{3};
    
    % re-assign cPyr activity
    for l=1:params.maxLevel
        for ori=1:params.bPrs.numOri
            cPyr{2}.subtype{1}(l).orientation(ori).data = bPyr1_1{2}.subtype{1}(l).orientation(ori).data;
            cPyr{2}.subtype{1}(l).orientation(ori+8).data = bPyr1_2{2}.subtype{1}(l).orientation(ori).data;
            cPyr{2}.subtype{3}(l).orientation(ori).data = bPyr1_1{2}.subtype{3}(l).orientation(ori).data;
            cPyr{2}.subtype{3}(l).orientation(ori+8).data = bPyr1_2{2}.subtype{3}(l).orientation(ori).data;
        end
    end
    
    % remove unused subtypes
    cPyr{2}.subtype([2 4])=[];
    bPyr1_1{2}.subtype([2 4])=[];
    bPyr1_1{2}.subname([2 4])=[];
    bPyr1_2{2}.subtype([2 4])=[];
    bPyr1_2{2}.subname([2 4])=[];
    bPyr2_1{2}.subtype([2 4])=[];
    bPyr2_1{2}.subname([2 4])=[];
    bPyr2_2{2}.subtype([2 4])=[];
    bPyr2_2{2}.subname([2 4])=[];
    
    % clean up temp variables
    clear btemp1 btemp2;

end


% iterative algorithm
for i=1:params.iterations
    fprintf(['\nIteration ', num2str(i), ':'])
    [gPyr1, gPyr2, bPyr1_1, bPyr1_2, bPyr2_1, bPyr2_2, cPyr] = makeGrouping(bPyr1_1,bPyr1_2,bPyr2_1,bPyr2_2,cPyr,params);
end

% Combine border-ownership maps
for i=1:size(bPyr1_1,2)
    for sub=1:size(bPyr1_1{i}.subtype,2)
        b_total1{i}.subtype{sub} = sumPyr(bPyr1_1{i}.subtype{sub},bPyr2_1{i}.subtype{sub});
        b_total2{i}.subtype{sub} = sumPyr(bPyr1_2{i}.subtype{sub},bPyr2_2{i}.subtype{sub});
    end
end

% Combine grouping maps
for i=1:size(gPyr1,2)
    for sub=1:size(gPyr1{i}.subtype,2)
        g_total{i}.subtype{sub} = sumPyr(gPyr1{i}.subtype{sub},gPyr2{i}.subtype{sub});
    end
end

% Combine the maps based on params.gray and params.color weights
group.data = zeros(size(im,1),size(im,2));

for l=1:params.maxLevel
    
    if strcmp(params.channels, 'IC')
        % luminance + color
        group.data = group.data + imresize(params.gray*g_total{1}.subtype{1}(l).data + (params.color/2)*g_total{2}.subtype{1}(l).data + (params.color/2)*g_total{2}.subtype{2}(l).data,[size(im,1) size(im,2)]);
    
        for ori=1:params.bPrs.numOri
            b1Pyr(l).orientation(ori).data = params.gray*b_total1{1}.subtype{1}(l).orientation(ori).data+(params.color/2)*b_total1{2}.subtype{1}(l).orientation(ori).data+(params.color/2)*b_total1{2}.subtype{2}(l).orientation(ori).data;
            b2Pyr(l).orientation(ori).data = params.gray*b_total2{1}.subtype{1}(l).orientation(ori).data+(params.color/2)*b_total2{2}.subtype{1}(l).orientation(ori).data+(params.color/2)*b_total2{2}.subtype{2}(l).orientation(ori).data;
        end  
    else
        % luminance only
        group.data = group.data + imresize(g_total{1}.subtype{1}(l).data,[size(im,1) size(im,2)]);
    
        for ori=1:params.bPrs.numOri
            b1Pyr(l).orientation(ori).data = b_total1{1}.subtype{1}(l).orientation(ori).data;
            b2Pyr(l).orientation(ori).data = b_total2{1}.subtype{1}(l).orientation(ori).data;
        end
    end
end

% visualize border ownership at the highest resolution
X = zeros(size(b1Pyr(1).orientation(1).data));
Y = zeros(size(b1Pyr(1).orientation(1).data));

for ori = 1:params.bPrs.numOri
    % BOS points towards outside of circle
    X = X + cos(params.bPrs.oris(ori)-pi/2).*(b2Pyr(1).orientation(ori).data-b1Pyr(1).orientation(ori).data);
    Y = Y + sin(params.bPrs.oris(ori)-pi/2).*(b2Pyr(1).orientation(ori).data-b1Pyr(1).orientation(ori).data);
end

% orientation
occ_map = atan2(X,Y);

% grouping
group_map = normalizeImage(group.data);
group_map = group_map.*(group_map>0.1); % threshold activity

% edge
b1 = zeros(size(b1Pyr(1).orientation(1).data));
b2 = zeros(size(b2Pyr(1).orientation(1).data));

for ori = 1:params.bPrs.numOri
    b1 = b1 + cos(params.bPrs.oris(ori)+occ_map).*(b1Pyr(1).orientation(ori).data);
    b2 = b2 + cos(params.bPrs.oris(ori)+occ_map-pi).*(b2Pyr(1).orientation(ori).data);
end

% separate out preferred/non-preferred BOS
BOS_pref = b1 .* (b1>0) + b2 .* (b2>0);
BOS_nonpref = -1*(b1 .* (b1<0) + b2 .* (b2<0));
edge_map = BOS_pref-BOS_nonpref;


% post-processing for thinned edges (based on Wang_Yuille16)
% new_edge = edge_nms(edge_map, 0.1*max(edge_map(:)));
% edge_map = normalizeImage(new_edge);
% occ_map = occ_map.*(new_edge>0); % Note this is in radians, not the color version


% outputs of function (edge map, BOS color map, and grouping cell map)
edge_map = normalizeImage(edge_map);
occ_map = vfcolor(X,Y);


% % write to file
outDir = 'output/';
imwrite(uint8(edge_map*255),fullfile(outDir,'edge/',sprintf('%s.bmp',filename(1:end-4))),'bmp');
imwrite(occ_map,fullfile(outDir,'ori/',sprintf('%s.jpg',filename(1:end-4))),'jpg');
imwrite(uint8(group_map*255),fullfile(outDir,'group/',sprintf('%s.bmp',filename(1:end-4))),'bmp');

fprintf('\nDone\n')
