imds = imageDatastore('data-USA/images','IncludeSubfolders',true,'FileExtensions','.jpg');
imds.Files=imds.Files((cellfun(@(x) isempty(regexp(x,'\._.*','ONCE')),imds.Files)));


annotds = fileDatastore('data-USA/annotations','IncludeSubfolders',true,...
    'FileExtensions','.txt','ReadFcn',@importbboxes);
annotds.Files=annotds.Files((cellfun(@(x) isempty(regexp(x,'\._.*','ONCE')),annotds.Files)));
annots = annotds.readall();

%%
ffps={};
bboxes={};
cur=1;
for i=1:4250%numel(annots)
    bbs=annots{i};
    ffps{cur}=imds.Files{i};
    bboxes{cur}=bbs;
    cur =cur+1;
end

td=table(ffps',bboxes','VariableNames',{'imageFilename','mypedestrian'});
disp('-');

%%
detector = trainACFObjectDetector(td,'NumStages',2,'ObjectTrainingSize',[50 21]);


%%
for i=1:1%4250%numel(annots)
    bbs=annots{i};
    img= imds.readimage(i);
    [bbox, score] = detect(detector, img,'Threshold',0);
    if numel(bbox)>0 break; end
    i,
end
  
img = insertShape(img, 'Rectangle', bbox);
img = insertShape(img, 'Rectangle', bbs, 'Color','blue');
imshow(img)

%%
for i=1:size(bbs,1)
    for j=1:numel(bboxes)
        if bboxOverlapRatio(bbs(i,:),bboxes{j})>0.5
            img = insertShape(img, 'Rectangle', bboxes{j});
        end
    end
end

img = insertShape(img, 'Rectangle', bbs, 'Color','red');
imshow(img)