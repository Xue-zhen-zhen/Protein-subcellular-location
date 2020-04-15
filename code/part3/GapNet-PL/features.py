# -*- coding: utf-8 -*-
"""
Created on Tue Jun  4 16:48:56 2019

@author: hp
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Apr  2 17:12:00 2018
@author: Heroin 高永标，upc
"""
 
import tensorflow as tf
 
#读取文件
def read_and_decode(filename,batch_size):
    #根据文件名生成一个队列
    filename_queue = tf.train.string_input_producer([filename])
 
    reader = tf.TFRecordReader()
    _, serialized_example = reader.read(filename_queue)   #返回文件名和文件
    features = tf.parse_single_example(serialized_example,
                                       features={
                                           'label': tf.FixedLenFeature([], tf.int64),
                                           'img_raw' : tf.FixedLenFeature([], tf.string),
                                       })
 
    img = tf.decode_raw(features['img_raw'], tf.uint8)
    img = tf.reshape(img, [224, 224, 3])                #图像归一化大小
   # img = tf.cast(img, tf.float32) * (1. / 255) - 0.5   #图像减去均值处理
    label = tf.cast(features['label'], tf.int32)        
 
    #特殊处理
 
    img_batch, label_batch = tf.train.shuffle_batch([img, label],
                                                    batch_size= batch_size,
                                                    num_threads=64,
                                                    capacity=2000,
                                                    min_after_dequeue=1500)
    return img_batch, tf.reshape(label_batch,[batch_size])
 
batch_size=16
dropout=0.3
 
tfrecords_file = 'validation.tfrecords'     #保存的测试数据
BATCH_SIZE = 16
image_batch, label_batch = read_and_decode(tfrecords_file,BATCH_SIZE)
#print(image_batch)
 
 
#sess=tf.InteractiveSession()
with tf.Session() as sess:
    coord = tf.train.Coordinator()  
    threads = tf.train.start_queue_runners(sess = sess,coord = coord)
    image,label=sess.run([image_batch,label_batch])  
    saver = tf.train.import_meta_graph("./model/checkpoint-751500.ckpt.meta")     #保存的模型路径
    saver.restore(sess, "./model/checkpoint-751500.ckpt")
    graph = tf.get_default_graph() 
    x_holder = graph.get_tensor_by_name("Features:0")  #    获取占位符
    fc3_features=graph.get_tensor_by_name("FC-3_2/Identity:0")     #获取要提取的特征，用名字
    keep_prob=graph.get_tensor_by_name("Placeholder:0")
    # 通过张量的名称来获取张量
 
    print(sess.run(fc3_features,feed_dict={x_holder:image,keep_prob:dropout}))  #给占位符重新赋值
    
    sess.close()    
