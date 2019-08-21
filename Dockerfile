FROM artifactory.cloud.cas.org/docker-hub/ubuntu:xenial as plumbing-docker
ENV LANG="C.UTF-8"

# Install OS packages.
RUN apt-get update -y \
    && apt-get install -y \
         apt-transport-https \
         curl \
         dnsutils \
         git \
         iptables \
         libltdl7 \
         python-dev=2.7.12-1~16.04 \
         python-pip=8.1.1-2ubuntu0.4 \
         software-properties-common \
         wget

# Setup our python env.
RUN python -m pip install -U pip==18.1 \
    && pip install -U setuptools==40.5.0 \
    && pip install -U pipenv==2018.5.18

# Install cas-ca-certs.
RUN curl \
      --silent \
      --show-error \
      --location \
      --insecure \
      --output cas-ca-certs.deb \
      "https://artifactory.cloud.cas.org/cas_debian/pool/cas-ca-certs_1.2.201810091539_all.deb" \
    && dpkg -i cas-ca-certs.deb \
    && rm -f cas-ca-certs.deb

# Clean up the image.
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG PACKAGE_NAME=cas-emaas-openstack

WORKDIR /usr/local/lib/${PACKAGE_NAME}

COPY Pipfile* ./
RUN pipenv --bare install --ignore-pipfile

COPY ansible ./ansible
COPY ansible.cfg ./ansible.cfg
COPY py ./py
COPY bin ./bin
COPY lib/* ./
