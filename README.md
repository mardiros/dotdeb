# Debian Packaging With Docker


Build you package, and host them with aptly using a docker container.


## Setup

```bash

docker pull mardiros/dotdeb                     # Pull the docker image
mkdir -p ${HOME}/workspace/aptly/{aptly,root}   # Create a directory to mount volumes

# Create an alias to keep "runtime" configuration of the container
alias dotdeb='docker run -t -i -v ${HOME}/workspace/aptly/repo:/aptly \
    -v ${HOME}/workspace/aptly/root:/root \
    -v $(pwd):/mnt \
    -v /dev/urandom:/dev/random \
    -p 8765:8765 \
    mardiros/dotdeb'

```

Note that the volume `/dev/urandom:/dev/random` is mount in order to
facilitate the creation of the GPG key. The GPG key is saved in the `/root` volume,
and the repo is created in the `/aptly` volume.
The current dir is mounted in `/mnt`, it is used when building the debian package.
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
```

### Run the packages repository

```bash
dotdeb aptly snapshot create aptly-snapshot from repo aptly-release 
dotdeb aptly -architectures=amd64 publish snapshot aptly-snapshot 
dotdeb aptly serve -listen=:8765
```

