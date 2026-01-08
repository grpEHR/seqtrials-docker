FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
RUN <<EOF
    set -e
    ARCH=$(dpkg --print-architecture)
    apt-get update; apt-get install -y wget time gnupg
    cd tmp
    # Install Quarto
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb

    # Install NVPL
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt-get update; apt-get -y install nvpl-blas nvpl-lapack
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/libblas.so.3 \
      libblas.so.3-aarch64-linux-gnu \
      /usr/lib/aarch64-linux-gnu/libnvpl_blas_lp64_omp.so.0 150
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/liblapack.so.3 \
      liblapack.so.3-aarch64-linux-gnu \
      /usr/lib/aarch64-linux-gnu/libnvpl_lapack_lp64_omp.so.0 150
    
    # Then set
    update-alternatives --set libblas.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_blas_lp64_omp.so.0
    update-alternatives --set liblapack.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_lapack_lp64_omp.so.0
    
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc', 'data.table.threads'))"
EOF
ENV OMP_NUM_THREADS=144
ENV OMP_PROC_BIND=close
ENV OMP_PLACES=cores
