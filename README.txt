4/15/2020

This code is tested in Matlab R2019a in WINDOWS 10 64 Bit.

This is the readme document for "Zhen-Zhen Xue, Yanxia Wu, Qing-Zu Gao, Liang Zhao and Ying-Ying Xu*. Automated classification of protein subcellular localization in immunohistochemistry images to reveal biomarkers in colon cancer."

You should:
1、Firstly run the DownloadThreeDataset.m to download the three datasets and store it in the ./part1/data/1_images/ and ./part2/data/1_images/  (the first dataset),  
./part4/data/biomarkerI/1_images/  (the second dataset),   ./part4/data/biomarkerII/1_images/  (the three dataset) folder, respectively .
if the image data has already been downloaded and stored in the corresponding folder, then DownloadThreeDataset.m need not be invoked.

2、Then run MainProcess.m to generate the results of our paper.