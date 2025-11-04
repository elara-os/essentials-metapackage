#!/bin/sh

BUILD_VERSION=$1
DEBIAN_DIST=$2

FULL_VERSION=${BUILD_VERSION}+${DEBIAN_DIST}_amd64
docker build . -t essentials-$DEBIAN_DIST  --build-arg DEBIAN_DIST=$DEBIAN_DIST --build-arg BUILD_VERSION=$BUILD_VERSION --build-arg FULL_VERSION=$FULL_VERSION
  id="$(docker create essentials-$DEBIAN_DIST)"
  docker cp $id:/essentials_$FULL_VERSION.deb - > ./essentials_$FULL_VERSION.deb
  tar -xf ./essentials_$FULL_VERSION.deb

