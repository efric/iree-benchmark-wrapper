FROM rocm/dev-ubuntu-22.04:6.3

RUN sudo apt-get update -y \
    && sudo apt-get install -y software-properties-common \
    && sudo add-apt-repository -y ppa:git-core/ppa \
    && sudo apt-get update -y \
    && sudo apt-get install -y --no-install-recommends \
    git \
    sudo \
    cmake \
    ninja-build \
    clang \
    lld \
    ccache \
    build-essential \
    python3.11 \
    python3.11-distutils \
    python3.11-venv \
    python3.11-dev \
    && sudo rm -rf /var/lib/apt/lists/*

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    sudo apt-get install git-lfs

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.11 1

RUN git clone --recurse-submodules https://github.com/iree-org/iree.git && \
    git clone https://github.com/nod-ai/iree-model-benchmark.git

WORKDIR /iree

RUN python -m pip install --upgrade pip && \
    python -m pip install runtime/ && \
    python -m pip install -r runtime/bindings/python/iree/runtime/build_requirements.txt

