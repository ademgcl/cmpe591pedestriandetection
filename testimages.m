%%
video = VideoWriter('detectionvideo.avi');
video.FrameRate=7;
open(video); 

jaccard1=zeros(numel(annots)-4250,1);
jaccard2=zeros(numel(annots)-4250,1);

for i=4251:numel(annots)
    bbs=annots{i}; bbs(find(bbs==0))=1;
    img= imds.readimage(i);
    %'inria-100x41'
    [bbspred] = detect(peopleDetectorACF('caltech-50x21'), img,'Threshold',-1); %detector
    %[bbspred2] = detect(peopleDetectorACF('inria-100x41'), img,'Threshold',-1); %detector

    %bbspred = [bbspred1;bbspred2];
    
    predres=zeros(1,size(bbspred,1));
    classifyres=zeros(1,size(bbspred,1));

    for j=1:size(bbspred,1)
        isPedestrian = 0;
        for k=1:size(bbs,1)
            if bboxOverlapRatio(bbs(k,:),bbspred(j,:))>0.5
                %img = insertShape(img, 'Rectangle', bbspred(j,:), 'Color','black');
                isPedestrian=1;
            end
        end
        predres(j)=isPedestrian;
        
        cb=bbspred(j,:);          
        cimg=img(cb(2):cb(2)+cb(4)-1,cb(1):cb(1)+cb(3)-1,:);
        classifyres(j) = classify(netTransfer,imresize(cimg,[224 224]));
    end
    
    
    for m=1:numel(predres)
        cb=bbspred(m,:);          
        cimg=img(cb(2):cb(2)+cb(4)-1,cb(1):cb(1)+cb(3)-1,:);
    end
    
   % img = insertShape(img, 'Rectangle', bbspred(find(classifyres~=2),:));
    img = insertShape(img, 'Rectangle', bbspred(find(classifyres==2),:),'Color','white');
    img = insertShape(img, 'Rectangle', bbs, 'Color','blue');
    imshow(img);
    writeVideo(video,img); %write the image to file
    
    b1=annotateBWImg(img,bbs);
    b2=annotateBWImg(img,bbspred(predres==1,:));
    b3=annotateBWImg(img,bbspred(classifyres==2,:));
    
    if ~isempty(jaccard(b1,b2))
    jaccard1(i-4250)=jaccard(b1,b2);
    end
    if ~isempty(jaccard(b1,b3))
    jaccard2(i-4250)=jaccard(b1,b3);
    end
    
end

close(video); 
%sum(jaccard1)
sum(jaccard2)