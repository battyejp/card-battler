# Use Debian Bookworm as base
FROM debian:bookworm

# Install basic dependencies
RUN apt-get update && apt-get -y install \
    git \
    curl \
    unzip \
    # Basic build tools
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    # C/C++ compilers
    gcc \
    g++ \
    clang \
    # GTK development libraries for Linux Flutter apps
    libgtk-3-dev \
    libgtk-3-0 \
    libgtk-3-bin \
    libgtk-3-common \
    # Additional development libraries
    liblzma-dev \
    libstdc++-12-dev \
    # Graphics and GL libraries
    libegl1-mesa-dev \
    libgl1-mesa-dev \
    libgles2-mesa-dev \
    libdrm2 \
    libxkbcommon0 \
    # Additional utilities
    xz-utils \
    zip

# Clean up apt cache
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
RUN mkdir /home/codespace
WORKDIR /home/codespace

# Environment variables
ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:$PATH"
ENV CXX=clang++
ENV CC=clang

# Install Flutter and configure
RUN git clone https://github.com/flutter/flutter && \
    /home/codespace/flutter/bin/flutter config --enable-web && \
    /home/codespace/flutter/bin/flutter doctor && \
    /home/codespace/flutter/bin/flutter precache