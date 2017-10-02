function img = generateChannels(im, params)
%Generates the data structure to hold the different channels the algorithm
%operates on
%
%Inputs:
%im - input image to algorithm
%params - model parameter structure
%
%outputs:
%img - data structure holding different feature channels

[in, R, G, B, Y] = makeColors(im);

%Generate color opponency channels
rg = R-G;
by = B-Y;
gr = G-R;
yb = Y-B;

%Threshold opponency channels
rg(rg<0) = 0;
gr(gr<0) = 0;
by(by<0) = 0;
yb(yb<0) = 0;

for c = 1:length(params.channels)
    if strcmp(params.channels(c),'I')
        %intensity
        img{c}.subtype{1}.data = in;
        img{c}.subtype{1}.type = 'Intensity';
        img{c}.type = 'Intensity';
    elseif strcmp(params.channels(c),'C')
        %color
        img{c}.type = 'Color';
        img{c}.subtype{1}.data = rg;
        img{c}.subtype{1}.type = 'Red-Green Opponency';
        
        img{c}.subtype{2}.data = gr;
        img{c}.subtype{2}.type = 'Green-Red Opponency';
        
        img{c}.subtype{3}.data = by;
        img{c}.subtype{3}.type = 'Blue-Yellow Opponency';
        
        img{c}.subtype{4}.data = yb;
        img{c}.subtype{4}.type = 'Yellow-Blue Opponency';
    end
end
