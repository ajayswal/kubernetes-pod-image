#!/usr/bin/env bash
set -ex

apt-get -q update
apt-get -y -q install \
    curl \
    bash \
    maven \
    sudo \
    python3-dev \
    python-dev \
    python3-pip \
    python-pip \
    dnsutils \
    iputils-* \
    openjdk-8-jdk

apt-get clean && apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* ~/.cache

python3 -m pip install --upgrade pip
pip3 install --no-cache-dir click \
    softlayer \
    markdown-generator \
    pyyaml

# install docker client
curl -fsSL get.docker.com | bash

# install kubectl client
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# install helm client
curl -L https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# install Bluemix client
curl -L https://clis.ng.bluemix.net/download/bluemix-cli/latest/linux64 | tar -xz
./Bluemix_CLI/install_bluemix_cli
