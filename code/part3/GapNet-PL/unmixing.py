# -*- coding: utf-8 -*-
"""
Created on Mon May 27 10:50:05 2019

@author: hp
"""

from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
import os
imgs=os.listdir('./literaturedata/cancer/')
imgNum = len(imgs)
for i in range (imgNum):
    img=np.array(Image.open('./literaturedata/cancer'+"/"+imgs[i])) #打开图像并转化为数字矩阵
    prot=img[:,:,1]
    nuc=img[:,:,0]
    img_merge=np.dstack([nuc,prot])
    index=imgs[i].find(')')
    index1=imgs[i].find('.')
    number=imgs[i][index+2:index1]
    num_fold=number+'.npz'
    np.savez('./npzs/'+num_fold,sample=img_merge)


plt.figure('cat')
plt.imshow(img)
plt.axis('on')
plt.show()