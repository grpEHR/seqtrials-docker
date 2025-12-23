FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
RUN <<EOF
    ARCH=$(dpkg --print-architecture)
    apt-get update; apt-get install -y wget time gnupg
    cd tmp
    # Install Quarto
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb

    # Install NVPL
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt-get update; apt-get remove -y libopenblas-dev; apt-get -y install nvpl-blas nvpl-lapack
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/libblas.so.3 \
      libblas.so.3-aarch64-linux-gnu \
      /usr/lib/aarch64-linux-gnu/libnvpl_blas_lp64_gomp.so 100
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/liblapack.so.3 \
      liblapack.so.3-aarch64-linux-gnu \
      /usr/lib/aarch64-linux-gnu/libnvpl_lapack_lp64_gomp.so 100
    
    # Then select them
    sudo update-alternatives --config libblas.so.3-aarch64-linux-gnu
    sudo update-alternatives --config liblapack.so.3-aarch64-linux-gnu
EOF


# Install NVPL
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/sbsa/cuda-keyring_1.1-1_all.deb
# dpkg -i cuda-keyring_1.1-1_all.deb
# apt-get update; apt-get remove -y libopenblas-dev; apt-get -y install nvpl
# update-alternatives --install /usr/lib/aarch64-linux-gnu/libblas.so.3 libblas.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_blas_core.so.0 100
# update-alternatives --set libblas.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_blas_core.so.0
# update-alternatives --install /usr/lib/aarch64-linux-gnu/libblas.so libblas.so-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_blas_core.so 100
# update-alternatives --set libblas.so-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_blas_core.so
# update-alternatives --install /usr/lib/aarch64-linux-gnu/liblapack.so.3 liblapack.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_lapack_core.so.0 100
# update-alternatives --set liblapack.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_lapack_core.so.0
# update-alternatives --install /usr/lib/aarch64-linux-gnu/liblapack.so liblapack.so-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_lapack_core.so 100
# update-alternatives --set liblapack.so-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libnvpl_lapack_core.so

# echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
# R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc'))"
