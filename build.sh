#!/usr/bin/env bash

sudo docker run --rm --privileged multiarch/qemu-user-static:register --reset
cp Dockerfile Dockerfile.${ARCH}
sed -i "s/__IMAGE_ARCH__/${IMAGE_ARCH}/" Dockerfile.${ARCH}
if [[ ! ${IMAGE_ARCH} == "amd64" ]]; then
  wget --quiet https://github.com/multiarch/qemu-user-static/releases/download/v3.0.0/qemu-${QEMU_ARCH}-static.tar.gz
  tar -xzf qemu-${QEMU_ARCH}-static.tar.gz
  sed -i "s/__CROSS_COPY__/COPY/" Dockerfile.${ARCH}
  sed -i "s/__QEMU_ARCH__/${QEMU_ARCH}/" Dockerfile.${ARCH}
else
  sed -i "/__CROSS_COPY__/d" Dockerfile.${ARCH}
fi
docker build --tag openblas/alpine:${ARCH} --file Dockerfile.${ARCH} .

if [[ $1 == "deploy" ]]; then
  echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin
  docker push openblas/alpine:${ARCH}
fi
