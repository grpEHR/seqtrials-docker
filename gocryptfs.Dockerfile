FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    gocryptfs \
    fuse3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
