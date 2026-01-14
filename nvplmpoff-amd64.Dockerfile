FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
ARG CUDA_VERSION=12-6

RUN <<EOF
    apt-get update
    apt-get install -y wget time gnupg
    
    # Install Quarto
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb

    # Install CUDA keyring for x86_64
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt-get update
    
    # Install libcublas (includes cuBLAS and NVBLAS)
    apt-get install -y libcublas-${CUDA_VERSION}
EOF
RUN <<EOF 
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc', 'data.table.threads'))"
EOF

# Create NVBLAS config
RUN cat > /etc/nvblas.conf << 'EOF'
NVBLAS_LOGFILE /tmp/nvblas.log
NVBLAS_CPU_BLAS_LIB /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
NVBLAS_GPU_LIST ALL
NVBLAS_AUTOPIN_MEM_ENABLED
NVBLAS_TILE_DIM 2048
EOF

# Environment for NVBLAS
ENV NVBLAS_CONFIG_FILE=/etc/nvblas.conf
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}

# To enable GPU offload at runtime, set:
# LD_PRELOAD=/usr/local/cuda/lib64/libnvblas.so.12
