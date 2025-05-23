FROM rocm/dev-ubuntu-22.04:6.3

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        git \
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
        libzstd-dev \
        unzip \
        pkg-config && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -y --no-install-recommends git-lfs && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    curl -sSL -O https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends azcopy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Python 3.11 as default and install pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.11 1

RUN git clone --recurse-submodules https://github.com/iree-org/iree.git && \
    git clone https://github.com/nod-ai/iree-model-benchmark.git

# Set working directory and install IREE runtime Python packages
WORKDIR /iree

RUN pip install --upgrade pip && \
    pip install runtime/ && \
    pip install -r runtime/bindings/python/iree/runtime/build_requirements.txt

