ARG FEDORA_VERSION
FROM docker.io/fedora:${FEDORA_VERSION}

RUN dnf update -y && \
    dnf install -y npm python gcc g++ make git rpm-build libxcrypt-compat patch

ARG NVM_VERSION
ARG SIGNAL_VERSION

# Install yarn and nvm
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

# Clone and patch Signal-Desktop to build an rpm instead of a deb package
COPY Signal-Desktop.patch /root/Signal-Desktop.patch
RUN cd /root && \
    git clone -b v${SIGNAL_VERSION} --depth 1 https://github.com/signalapp/Signal-Desktop.git && \
    cd Signal-Desktop && \
    patch -p1 < /root/Signal-Desktop.patch

# Build Signal-Desktop
RUN cd /root/Signal-Desktop && \
    source $NVM_DIR/nvm.sh --no-use && \
    nvm install $(curl -o- https://raw.githubusercontent.com/signalapp/Signal-Desktop/v${SIGNAL_VERSION}/.nvmrc) && \
    nvm use

RUN npm install -g pnpm
RUN cd /root/Signal-Desktop && \
    pnpm install && \
    pnpm run generate && \
    pnpm run build

# Export rpm and clean
RUN mkdir -p /output && \
    cp /root/Signal-Desktop/release/signal-desktop-*.rpm /output && \
    rm -rf /root/Signal-Desktop
