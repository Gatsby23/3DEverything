#!/usr/bin/env sh
# Create the lmdb inputs
# N.B. set the path to the image dir

EXAMPLE=.
DATA=/scratch/yuxiang/Projects/3DEverything/Primitives
TOOLS=.

TRAIN_DATA_ROOT=/scratch/yuxiang/Projects/3DEverything/Primitives/training_images/

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=false
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$TRAIN_DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imageset.sh to the path" \
       "where the rendering data is stored."
  exit 1
fi

echo "Creating train image lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $TRAIN_DATA_ROOT \
    $DATA/train_images.txt \
    $EXAMPLE/train_images_lmdb

echo "Creating train depth lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $TRAIN_DATA_ROOT \
    $DATA/train_depths.txt \
    $EXAMPLE/train_depths_lmdb

echo "Creating test image lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $TRAIN_DATA_ROOT \
    $DATA/test_images.txt \
    $EXAMPLE/test_images_lmdb

echo "Creating test depth lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    --gray \
    $TRAIN_DATA_ROOT \
    $DATA/test_depths.txt \
    $EXAMPLE/test_depths_lmdb

echo "Done."
