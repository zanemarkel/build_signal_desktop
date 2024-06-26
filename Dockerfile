ARG FEDORA_VERSION
FROM docker.io/fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y unzip g++ npm python make gcc git rpm-build libxcrypt-compat patch

# Install git-lfs and pip packaging
# python3-pip and packaging were added because Fedora 39 moves to python 3.12,
# which deprecates distutils used by node-gyp
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash && \
    dnf install -y git-lfs && \
    git lfs install && \
    dnf install -y python3-pip && \
    pip install packaging && \
    dnf clean all

ARG NVM_VERSION
ARG SIGNAL_VERSION

# Install yarn and nvm
ENV NVM_DIR /root/.nvm
RUN npm install --global yarn && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash && \
    source /root/.nvm/nvm.sh --no-use && \
    nvm install $(curl -o- https://raw.githubusercontent.com/signalapp/Signal-Desktop/v${SIGNAL_VERSION}/.nvmrc)

# Clone and patch Signal-Desktop
COPY Signal-Desktop.patch /root/Signal-Desktop.patch
RUN cd /root && \
    git clone -b v${SIGNAL_VERSION} --depth 1 https://github.com/signalapp/Signal-Desktop.git && \
    cd Signal-Desktop && \
    patch -p1 < /root/Signal-Desktop.patch

# Build Signal-Desktop
RUN cd /root/Signal-Desktop && \
    source /root/.nvm/nvm.sh --no-use && \
    nvm use && \
    (yarn install --frozen-lockfile || yarn install --frozen-lockfile) && \
    yarn generate && \
    yarn build-release

# Export rpm and clean
RUN mkdir -p /output && \
    cp /root/Signal-Desktop/release/signal-desktop-*.rpm /output && \
    rm -rf /root/Signal-Desktop
