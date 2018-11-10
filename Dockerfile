FROM __IMAGE_ARCH__/alpine
__CROSS_COPY__ qemu-__QEMU_ARCH__-static /usr/bin
RUN apk add --no-cache clang-dev cmake gfortran g++ linux-headers make
