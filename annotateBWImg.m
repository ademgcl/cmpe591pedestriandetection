function bwimg = annotateBWImg(img,bboxes)
    bwimg = zeros(size(img,1),size(img,2));
    for i=1:size(bboxes,1)
        cbbox=bboxes(i,:);
        if cbbox(2)+cbbox(4)>size(img,1) to1=size(img,1); 
        else to1=cbbox(2)+cbbox(4); end
        if cbbox(1)+cbbox(3)>size(img,2) to2=size(img,2); 
        else to2=cbbox(1)+cbbox(3); end

        if cbbox(2)<=0 from1=1; else from1=cbbox(2); end
        if cbbox(1)<=0 from2=1; else from2=cbbox(1); end
                    
        bwimg(from1:to1,from2:to2)=1;
    end
end