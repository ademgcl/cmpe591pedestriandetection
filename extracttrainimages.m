imds = imageDatastore('data-USA/images','IncludeSubfolders',true,'FileExtensions','.jpg');
imds.Files=imds.Files((cellfun(@(x) isempty(regexp(x,'\._.*','ONCE')),imds.Files)));


annotds = fileDatastore('data-USA/annotations','IncludeSubfolders',true,...
    'FileExtensions','.txt','ReadFcn',@importbboxes);
annotds.Files=annotds.Files((cellfun(@(x) isempty(regexp(x,'\._.*','ONCE')),annotds.Files)));
annots = annotds.readall();

%
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
for i=1:4250%numel(annots)
    bbs=annots{i};
    img= imds.readimage(i);
    for j=1:size(bbs,1)
        cbbox=bbs(j,:);
        if cbbox(3)>5 && cbbox(4)>5
            if cbbox(2)+cbbox(4)>size(img,1) to1=size(img,1); 
            else to1=cbbox(2)+cbbox(4); end
            if cbbox(1)+cbbox(3)>size(img,2) to2=size(img,2); 
            else to2=cbbox(1)+cbbox(3); end

            if cbbox(2)<=0 from1=1; else from1=cbbox(2); end
            if cbbox(1)<=0 from2=1; else from2=cbbox(1); end
            
            cimg=img(from1:to1,from2:to2,:);
            imwrite(cimg,strcat('trainimgs/1/',num2str(i),'-',num2str(j),'.jpg'));
        end
    end
end

disp('done');

%%


for i=1:4250%numel(annots)
    bbs=annots{i};
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
            if bboxOverlapRatio(bbs(k,:),bbspred(j,:))>0.25
                %img = insertShape(img, 'Rectangle', bbspred(j,:), 'Color','black');
                isPedestrian=1;
            end
        end
        predres(j)=isPedestrian;
        
        cb=bbspred(j,:);          
        cimg=img(cb(2):cb(2)+cb(4)-1,cb(1):cb(1)+cb(3)-1,:);
        %classifyres(j) = classify(netTransfer,imresize(cimg,[224 224]));
    end
    
    
    for m=1:numel(predres)
        cb=bbspred(m,:);          
        cimg=img(cb(2):cb(2)+cb(4)-1,cb(1):cb(1)+cb(3)-1,:);
        imwrite(cimg,strcat('trainimgs/',num2str(predres(m)),'/p',num2str(i),'-',num2str(m),'.jpg'));
    end
    
    %img = insertShape(img, 'Rectangle', bbspred(find(classifyres~=2),:));
    %img = insertShape(img, 'Rectangle', bbspred(find(classifyres==2),:),'Color','white');
    img = insertShape(img, 'Rectangle', bbs, 'Color','blue');
    imshow(img);
    
    
    
end
  

