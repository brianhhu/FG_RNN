% Create subplot
ha = tight_subplot(3,4,0.01,[0.01 0.01],[0.01 0.01]);

% for grayscale and color images on same axis
cmap = [gray(64); jet(64)]; % new colormap
colormap(cmap)

% image 1
im_path = '42049.jpg';
[e, o, g] = runProtoGroup(im_path);
axes(ha(1)); imagesc(imread(im_path));
axes(ha(2)); imagesc(1-e-1/64); caxis([0 2]);
axes(ha(3)); imagesc(o);
axes(ha(4)); imagesc(1+g.*(g>0.1)); caxis([0 2]);

% image 2
im_path = '12074.jpg';
[e, o, g] = runProtoGroup(im_path);
axes(ha(5)); imagesc(imread(im_path));
axes(ha(6)); imagesc(1-e-1/64); caxis([0 2]);
axes(ha(7)); imagesc(o);
axes(ha(8)); imagesc(1+g.*(g>0.1)); caxis([0 2]);

% image 3
im_path = '156079.jpg';
[e, o, g] = runProtoGroup(im_path);
axes(ha(9)); imagesc(imread(im_path));
axes(ha(10)); imagesc(1-e-1/64); caxis([0 2]);
axes(ha(11)); imagesc(o);
axes(ha(12)); imagesc(1+g.*(g>0.1)); caxis([0 2]);

set(ha(1),'XTick',[]);
set(ha(1),'YTick',[]);
set(ha(2),'XTick',[]);
set(ha(2),'YTick',[]);
set(ha(3),'XTick',[]);
set(ha(3),'YTick',[]);
set(ha(4),'XTick',[]);
set(ha(4),'YTick',[]);
set(ha(5),'XTick',[]);
set(ha(5),'YTick',[]);
set(ha(6),'XTick',[]);
set(ha(6),'YTick',[]);
set(ha(7),'XTick',[]);
set(ha(7),'YTick',[]);
set(ha(8),'XTick',[]);
set(ha(8),'YTick',[]);
set(ha(9),'XTick',[]);
set(ha(9),'YTick',[]);
set(ha(10),'XTick',[]);
set(ha(10),'YTick',[]);
set(ha(11),'XTick',[]);
set(ha(11),'YTick',[]);
set(ha(12),'XTick',[]);
set(ha(12),'YTick',[]);

set(gcf,'Color','w');
