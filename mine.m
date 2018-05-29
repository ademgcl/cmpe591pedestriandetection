imagedir=dir('data-USA/images/set00/V014');
imagedir=imagedir(~ismember({imagedir.name},{'.','..'}));

annotdir=dir('data-USA/annotations/set00/V014');
annotdir=annotdir(~ismember({annotdir.name},{'.','..'}));

ffps={};
bboxes={};
cur=1;
for i=1:numel(annotdir)
    ffp=fullfile(annotdir(i).folder,annotdir(i).name);
    ffpi=fullfile(imagedir(i).folder,imagedir(i).name);
    bbs=importbboxes(ffp);
    for j=1:size(bbs,1)
        ffps{cur}=ffpi;
        bboxes{cur}=bbs(j,:);
        cur=cur+1;
    end
end

td=table(ffps',bboxes','VariableNames',{'imageFilename','mypedestrian'});


%%

%layers = data.layers;

options = trainingOptions('sgdm', ...
      'InitialLearnRate', 1e-3, ...
      'MaxEpochs', 5, ...   
      'VerboseFrequency', 200, ...
      'CheckpointPath', tempdir);
  
  detector = trainFastRCNNObjectDetector(td, layers, options);
  
  
  %%
  
  for i=1:numel(annotdir)
    ffp=fullfile(annotdir(i).folder,annotdir(i).name);
    ffpi=fullfile(imagedir(i).folder,imagedir(i).name);
    bbs=importbboxes(ffp);
    img= imread(ffpi);
    [bbox, score] = detect(detector, img);
    if numel(bbox)>0 break; end
    i,
  end
  
 img = insertShape(img, 'Rectangle', bbox);
 img = insertShape(img, 'Rectangle', bbs, 'Color','red');
imshow(img)