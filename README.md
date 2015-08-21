# sirius-docker

## Modifications from origin Dockerfile
- Updated to Ubuntu 14.04 LTS
- Using OpenBLAS optimised for specific CPU architecture
- Kaldi built optimised for specific CPU architecture
- Make threading uses all cores

## Build the image
Modify the GCC and OpenBlAS CPU types to optimize for your specific environment.

Build the image with the following command:
```
$ docker build -tag sirius-docker .
```

##Start a container
In order to use the Docker image you have just build or pulled use:
```
$ docker run -it --name sirius-docker sirius-docker /bin/bash
```
