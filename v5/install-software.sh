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

# install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install -y sbt
#install and setup terraform
sudo apt-get install -y unzip
wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
unzip ./terraform_0.11.14_linux_amd64.zip -d /usr/local/bin/
# wget https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v0.21.0/linux_amd64.zip
# unzip ./linux_amd64.zip -d $HOME/.terraform.d/plugins
