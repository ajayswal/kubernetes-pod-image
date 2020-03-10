FROM ubuntu:xenial

# USER root

# Install Essentials
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:openjdk-r/ppa && \
    apt-get update -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

# Install Packages
RUN apt-get -qq update -y && \
    apt-get -q install -y \
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        # Add new packages to install here:
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        openjdk-8-jdk \
        sudo \
        wget \
        # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

# Run a custom script to install additional software
COPY install-software.sh /usr/local/bin/install-software.sh
RUN chmod +x /usr/local/bin/install-software.sh
RUN install-software.sh
    
COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod +x /usr/local/bin/jenkins-slave

# Set up Jenkins user
RUN useradd --shell /bin/bash --create-home --groups docker jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod u+s /usr/bin/sudo /bin/ping

#ENV GOROOT=/usr/local/go
#ENV GOPATH=$HOME/go
#ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
#ENV GRADLE_HOME=/opt/packages/gradle
#ENV LC_ALL=C.UTF-8
#ENV LANG=C.UTF-8
ENV HOME /home/jenkins
ARG AGENT_VERSION=3.9
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${AGENT_VERSION}/remoting-${AGENT_VERSION}.jar
RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar

USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}
VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-slave"]