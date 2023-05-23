FROM condaforge/miniforge3:23.1.0-1
LABEL maintainer="Erik Ferlanti <eferlanti@tacc.utexas.edu>"

# Configure ENV
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add docker-clean script
COPY extras/docker-clean /usr/bin/docker-clean
RUN chmod a+rx /usr/bin/docker-clean && docker-clean

# Install system dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        less \
        libxcb-xinerama0 \
        libxcb-xinerama0-dev \
        libxkbcommon-x11-0 \
        xvfb \
        libxcb-xv0 \
        libxkbcommon-x11-dev \
        libxcb-xtest0-dev \
        libxcb-randr0-dev \
        libxcb-xinerama0-dev \
        libxcb-shape0-dev \
        libxcb-xkb-dev \
        libxcb-icccm4-dev \
        libxcb-image0-dev \
        libxcb-keysyms1-dev \
        libxcb-render-util0-dev \
        libx11-xcb-dev \
        libglu1-mesa-dev \
        libxrender-dev \
        libxi-dev \
        x11-utils \
        x11-xserver-utils \
        libdbus-1-3 \
    && docker-clean

# COPY in the conda environment yaml file
COPY napari.yml /tmp/napari.yml

# install the custom conda environment
ARG ENV_NAME=napari
RUN conda env create -f /tmp/napari.yml -n ${ENV_NAME} \
    && echo "conda activate ${ENV_NAME}" >> /etc/skel/.bashrc \
    && echo "conda activate ${ENV_NAME}" >> ~/.bashrc \
    && rm -f /tmp/napari.yml \
    && docker-clean

ENV PATH=/opt/conda/envs/${ENV_NAME}/bin:$PATH

