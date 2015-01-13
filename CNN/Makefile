################################################################################
# Cuda
################################################################################
CUDA_INCLUDES := /usr/local/cuda/include

################################################################################
# Caffe
################################################################################
CAFFE_INCLUDES := /home/yuxiang/Projects/caffe/include
CAFFE_BUILD_INCLUDES := /home/yuxiang/Projects/caffe/build/src
CAFFE_LIBS := /home/yuxiang/Projects/caffe/build/lib

CC = g++
LD = g++

CFLAGS = -O3 -Wall -g
LDFLAGS = -O3 -lm -Wall -lcaffe -lglog -lgflags -lprotobuf -lleveldb -llmdb -lboost_thread

INCLUDES += -I$(CAFFE_INCLUDES) -I$(CAFFE_BUILD_INCLUDES) -I$(CUDA_INCLUDES)
LIBRARIES += -L$(CAFFE_LIBS)

# Target rules
SRC_C = convert_imageset.cpp

OBJ_C = $(addsuffix .o, $(basename $(SRC_C)))

all: convert_imageset

convert_imageset: $(OBJ_C)
	$(CC) -o $@ $+ $(LDFLAGS) $(LIBRARIES) 

%.o: %.cpp
	$(CC) $(INCLUDES) $(CFLAGS) -o $@ -c $<

clean: $(OBJ)
	rm -f $(OBJ_C)
	rm -f convert_imageset
