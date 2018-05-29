imagedir=dir('data-USA/images/set00/V014');
imagedir=imagedir(~ismember({imagedir.name},{'.','..','._*'}));

annotdir=dir('data-USA/annotations/set00/V014');
annotdir=annotdir(~ismember({annotdir.name},{'.','..','._*'}));


detector = peopleDetectorACF('caltech-50x21');

%[bbox, score] = detect(detector, img);

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
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'ValidationPatience',Inf, ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(augimdsTrain,layers,options);
