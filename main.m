imagedir=dir('data-USA/images/set00/V014');
imagedir=imagedir(~ismember({imagedir.name},{'.','..'}));
imagedir=imagedir(cellfun(@(x) isempty(regexp(x,'\._.*','ONCE')),{imagedir.name}));

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

%detector = peopleDetectorACF;
detector = trainACFObjectDetector(td);

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
  
%img = insertShape(img, 'Rectangle', bbox);


for i=1:size(bbs,1)
    for j=1:numel(bboxes)
        if bboxOverlapRatio(bbs(i,:),bboxes{j})>0.5
            img = insertShape(img, 'Rectangle', bboxes{j});
        end
    end
end

img = insertShape(img, 'Rectangle', bbs, 'Color','red');
imshow(img)
%%

net =vgg16;
inputSize = net.Layers(1).InputSize;
layersTransfer = net.Layers(1:end-3);

numClasses=2;
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(td,layers,options);

