#!/bin/bash
set -e
set -x

LOCAL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
ROOT_DIR=$(dirname "$LOCAL_DIR")
cd "$ROOT_DIR"

APT_INSTALL_CMD='sudo apt-get install -y --no-install-recommends'

if [ "$TRAVIS_OS_NAME" = 'linux' ]; then
    ####################
    # apt dependencies #
    ####################
    sudo apt-get update
    $APT_INSTALL_CMD \
	build-essential \
	libgoogle-glog-dev \
	libgflags-dev \
	libeigen3-dev \
	libopencv-dev \
	libcppnetlib-dev \
	libboost-dev \
	libboost-iostreams-dev \
	libcurl4-openssl-dev \
	protobuf-compiler \
	libopenblas-dev \
	libhdf5-dev \
	libprotobuf-dev \
	libleveldb-dev \
	libsnappy-dev \
	liblmdb-dev \
	libutfcpp-dev \
	libarchive-dev \
	libspdlog-dev \
	rapidjson-dev

        # build curlpp
        git clone https://github.com/jpbarrette/curlpp.git
	cd curlpp
	cmake .
	sudo make install
	sudo cp /usr/local/lib/libcurlpp.* /usr/lib/
    
        ################
        # Install CUDA #
        ################
        CUDA_REPO_PKG='cuda-repo-ubuntu1604_8.0.44-1_amd64.deb'
        CUDA_PKG_VERSION='8-0'
        CUDA_VERSION='8.0'
        wget "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_REPO_PKG}"
        sudo dpkg -i "$CUDA_REPO_PKG"
        rm -f "$CUDA_REPO_PKG"
        sudo apt-get update
        $APT_INSTALL_CMD \
            "cuda-core-${CUDA_PKG_VERSION}" \
            "cuda-cublas-dev-${CUDA_PKG_VERSION}" \
            "cuda-cudart-dev-${CUDA_PKG_VERSION}" \
            "cuda-curand-dev-${CUDA_PKG_VERSION}" \
            "cuda-driver-dev-${CUDA_PKG_VERSION}" \
            "cuda-nvrtc-dev-${CUDA_PKG_VERSION}" \
	    "cuda-cusparse-dev-${CUDA_PKG_VERSION}"
        # Manually create CUDA symlink
        sudo ln -sf /usr/local/cuda-$CUDA_VERSION /usr/local/cuda
    fi
else
    echo "OS \"$TRAVIS_OS_NAME\" is unknown"
    exit 1
fi

####################
# pip dependencies #
####################
## As needed
