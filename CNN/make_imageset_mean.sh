#!/usr/bin/env sh
# Compute the mean image from the training lmdb

CAFFE_ROOT=/opt/caffe-master
#CAFFE_ROOT=/home/yuxiang/Projects/caffe

$CAFFE_ROOT/build/tools/compute_image_mean train_images_lmdb imageset_mean.binaryproto

echo "Done."
