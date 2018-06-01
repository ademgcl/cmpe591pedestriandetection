# cmpe591pedestriandetection
Prerequites: 
- Matlab r2018a
- Piotr's Matlab Toolbox (version 3.20 or later) https://pdollar.github.io/toolbox/
- Dataset Labelling code http://www.vision.caltech.edu/Image_Datasets/CaltechPedestrians/code/code3.2.1.zip

Dataset: The Caltech Pedestrian Dataset - http://www.vision.caltech.edu/Image_Datasets/CaltechPedestrians/datasets/USA/

Demonstration Video: https://www.youtube.com/watch?v=l2FHUb3tBm8


#running the project
- run dbExtract.m to extract frames from the videos (Piotr's Matlab Toolbox)
- run extracttrainimages.m to extract training images for VGG-16 transfer learning
- run allimages.m to train ACF detector
- run testimages.m to run the testing, the demo video is automatically extracted as detectionvideo.avi

- annotateBWImg.m helps bounding box labelling in jaccard index calculation
- importbboxes.m help reading and mapping the image - ground truth
- mine.m, mineacf.m and main.m are old versions of my work.
- rest db* and vbb* are Piotr's open labelling codes.

