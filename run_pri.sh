#!/bin/bash

# This must be run as root!

CUDA_VISIBLE_DEVICES=0

for (( i=0; i>=-5; i-=1 )); do
	echo "Running: $(((i*-1)+1)) of 6"
	sed -i "s/A_bit =.*/A_bit = "$i";/g" src/detector.c;
	sed -i "s/B_bit =.*/B_bit = "$((-5-i))";/g" src/detector.c;
	make
	(sleep 15; ../liblitmus/release_ts) & ./darknet detector rtas23-pri cfg/voc-rtas23.data cfg/yolov2-voc.cfg yolov2-voc.weights -out rtas23;
done
