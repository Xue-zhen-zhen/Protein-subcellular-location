This code is tested in Matlab R2019a in WINDOWS 10 64 Bit.

datainformation.xlsx stores the MD dataset information, You should download the image data in the MD dataset and store it in the ./part1/data/1_images folder and ./part2/data/1_images folder.
The image data of the two biomarker datasets are saved in ./part4/data/biomarkerI/1_images and ./part4/data/biomarkerII/1_images respectively.

Running steps:

1、The part1 is to run on the whole image. Run the processDatamain.m to process the images and recreate the results in the article.

2、The part2 is to extract the patch from the whole image. Run the Main.m to process the images and recreate the results in the article.

3、The part3 is the use of the extracted patches from whole image for deep learning. In folder ./part3/pretrainednetworks, run ExtractPatchMain.m to create image patch, run pretrainedNetworkMain.m to  Perform transfer learning,
run DeepFeat1000Main.m to generate deep network features.

4、The part4 is the experimental part of the two biomarker datasets. Run the processDatamain.m to process the images. In the folder .\part4\SLFsfeaturesttestresult\7model, run the datattest2main.m
to get the experimental results of this part
