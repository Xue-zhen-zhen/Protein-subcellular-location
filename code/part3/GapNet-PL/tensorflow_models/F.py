# -*- coding: utf-8 -*-
"""
Created on Wed Jun  5 11:25:08 2019

@author: hp
"""

import warnings

import matplotlib
import numpy as np
import numpy
from sklearn.metrics import f1_score
from tqdm import tqdm

matplotlib.use("agg")

# Import TeLL
from TeLL.config import Config
from TeLL.regularization import regularize
from TeLL.session import TeLLSession
from TeLL.utility.misc import AbortRun
from TeLL.utility.timer import Timer

# Import Tensorflow
if __name__ == "__main__":
    import tensorflow as tf
    import numpy as np
    import torch
    from pyll_functions import invoke_dataset_from_config

def main(_):
    config = Config()
    np.random.seed(config.get_value("random_seed", 12345))
    
    # PARAMETERS
    n_epochs = config.get_value("epochs", 100)
    batchsize = config.get_value("batchsize", 8)
    n_classes = config.get_value("n_classes", 3)
    dropout = config.get_value("dropout", 0.25)  # TODO
    num_threads = config.get_value("num_threads", 0)    # zzxue
    initial_val = config.get_value("initial_val", True)
    
    # READER, LOADER
    readers = invoke_dataset_from_config(config)
    reader_train = readers["train"]
    reader_val = readers["val"]
    train_loader = torch.utils.data.DataLoader(reader_train, batch_size=config.batchsize, shuffle=True,
                                               num_workers=num_threads)
    val_loader = torch.utils.data.DataLoader(reader_val, batch_size=1, shuffle=False, num_workers=num_threads)
    feats = np.zeros([24080, 256])
    vafeats = np.zeros([2625,256])
    with tf.Session() as sess:
        saver = tf.train.import_meta_graph("./model/checkpoint-752500.ckpt.meta")     #保存的模型路径
        saver.restore(sess, "./model/checkpoint-752500.ckpt")
        graph = tf.get_default_graph() 
        tensor_name_list = [tensor.name for tensor in graph.as_graph_def().node]# 得到当前图中所有变量的名称
        x_holder = graph.get_tensor_by_name("Features:0")  #    获取占位符
        fc3_features=graph.get_tensor_by_name("FC-2_2/selu/mul_1:0")     #获取要提取的特征，用名字FC-3_2/IdentityFC-2_2/selu/mul_1:0
        keep_prob=graph.get_tensor_by_name("Placeholder:0") #Labels:0
        for mbi, mb in enumerate(train_loader):
            feature = sess.run(fc3_features, feed_dict={x_holder:mb['input'].numpy(),keep_prob:dropout})  #
#            if mbi==1502:
#                feats[24032:24035,:]=feature
#            else:
#                feats[mbi*16:(mbi+1)*16,:]=feature
            feats[mbi*16:(mbi+1)*16,:]=feature
        for vbi, vmb in enumerate(val_loader):
            valfeature = sess.run(fc3_features, feed_dict={x_holder:vmb['input'].squeeze().numpy(),keep_prob:dropout})
            val_feat=np.mat(valfeature)
            vafeats[vbi,:]=np.mean(val_feat,0)
#            if vbi==667:
#                vafeats[2668:2670]=valfeature
#            else:
#                vafeats[vbi*4:(vbi+1)*4,:]=valfeature
    numpy.savetxt("traindata.txt", feats);
    numpy.savetxt("validationdata.txt", vafeats);        
    a=1
    return feature
    
    
if __name__ == "__main__":
    tf.app.run()