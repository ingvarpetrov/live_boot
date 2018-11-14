#!/bin/bash

CURRENT_FOLDER=$(pwd)

cd deps/undocker
docker build -t layer_base_os .
cd $CURRENT_FOLDER

echo "Starting docker container. Make sure that everything works well. Press ctrl+d after you done."
docker run -i -t layer_base_os /sbin/my_init -- bash -l

echo "exporting docker container..."
docker export $(docker ps -aql) | pigz --fast -p$(nproc) > __bin/layer_base_os.tar.gz
