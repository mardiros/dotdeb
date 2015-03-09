# Debian Packaging With Docker


Build you package, and host them with aptly using a docker container.

The aim of this container is for development purpose.


## Setup

```bash

docker pull mardiros/dotdeb                     # Pull the docker image
mkdir -p ${HOME}/workspace/aptly/{aptly,root,sources.list.d}   # Create a directory to mount volumes

# Create an alias to keep "runtime" configuration of the container
alias dotdeb='docker run -t -i -v ${HOME}/workspace/aptly/repo:/aptly \
    -v ${HOME}/workspace/aptly/root:/root \
    -v $(pwd):/mnt \
    -v /dev/urandom:/dev/random \
    -v ${HOME}/workspace/aptly/sources.list.d:/etc/apt/sources.list.d \
    mardiros/dotdeb'

# Create a specific alias to expose the port
alias dotdeb-serve='docker run -t -i -v ${HOME}/workspace/aptly/repo:/aptly \
    -v ${HOME}/workspace/aptly/root:/root \
    -p 8765:8765 \
    mardiros/dotdeb \
    aptly serve -listen=:8765'

```

Note that the volume `/dev/urandom:/dev/random` is mount in order to
facilitate the creation of the GPG key. The GPG key is saved in the `/root` volume,
and the repo is created in the `/aptly` volume.
The current dir is mounted in `/mnt`, it is used when building the debian package.
The `sources.list.d` is mounted in `/etc/apt/` to add new debian packages sources.
The port `8765` will be used to serve the repository.

### create the repository

```bash
dotdeb aptly -architectures=amd64 repo create -distribution=wheezy -component=main aptly-release
```


### build a package
```bash
cd a_project_having_a_debian_directory
dotdeb makedeb
```

### Push it in the repository

```bash
cd a_project_having_a_debian_directory
dotdeb aptly -architectures=amd64 repo add aptly-release *.deb
dotdeb aptly publish repo  -architectures=amd64  aptly-release
```


Note that for the next package, you don't have to publish it, but
to update it with the command:

```bash
dotdeb aptly publish update wheezy
```


### Run the packages repository

```bash
dotdeb-serve
```



