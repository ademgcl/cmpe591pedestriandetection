%%
imdstl = imageDatastore('trainimgs','IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames');
%imdstl.Files=imdstl.Files((cellfun(@(x) isempty(regexp(x,'\._.*','ONCE')),imdstl.Files)));

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

%pixelRange = [-10 10];
imageAugmenter = imageDataAugmenter('RandXReflection',true);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdstl,'DataAugmentation',imageAugmenter);

options = trainingOptions('sgdm', ...
    'MiniBatchSize',64, ...
    'MaxEpochs',5, ...
    'InitialLearnRate',1e-4, ...
    'Verbose',false ,...
    'Plots','training-progress',...
    'ExecutionEnvironment','multi-gpu');

%%
netTransfer = trainNetwork(augimdsTrain,layers,options);


