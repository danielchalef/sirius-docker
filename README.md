# sirius-docker

## Modifications from original Dockerfile
- Updated to Ubuntu 14.04 LTS
- Using OpenBLAS optimised for specific CPU architecture
- Kaldi built optimised for specific CPU architecture
- `make` threading uses all cores

## To Do
- Optimise IMM & QA

## Build the image
Modify the GCC and OpenBLAS CPU types to optimize for your specific environment:
- GCC: `CCFLAGS="-mtune=<your_gcc_arch"`
- OpenBLAS add `make` argument `TARGET=<your OpenBLAS CPU arch>` (see CPU target list in OpenBLAS distribution) 

Build the image with the following command:
```
$ docker build -tag sirius-docker .
```
##Start a container
In order to use the Docker image you have just built use:
```
$ docker run -it --name sirius-docker sirius-docker /bin/bash
```
