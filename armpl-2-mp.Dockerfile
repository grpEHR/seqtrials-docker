FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
# 24.10.1
ARG ARMPL_VERSION=25.07.1
RUN <<EOF
    ARCH=$(dpkg --print-architecture)
    apt-get update; apt-get install -y wget time gnupg environment-modules
    cd tmp
    # Install Quarto
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    # Install ARMPL
    wget https://developer.arm.com/-/cdn-downloads/permalink/Arm-Performance-Libraries/Version_${ARMPL_VERSION}/arm-performance-libraries_${ARMPL_VERSION}_deb_gcc.tar
    tar -xf arm-performance-libraries_${ARMPL_VERSION}_deb_gcc.tar
    ./arm-performance-libraries_${ARMPL_VERSION}_deb/arm-performance-libraries_${ARMPL_VERSION}_deb.sh --accept --install-to /opt/arm
    rm -rf arm-performance-libraries*
    
    # ARMPL installs to /opt/arm/armpl_${ARMPL_VERSION}_gcc/lib
    ARMPL_LIB=/opt/arm/armpl_${ARMPL_VERSION}_gcc/lib
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/libblas.so.3 \
      libblas.so.3-aarch64-linux-gnu \
      ${ARMPL_LIB}/libarmpl_lp64_mp.so 150
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/liblapack.so.3 \
      liblapack.so.3-aarch64-linux-gnu \
      ${ARMPL_LIB}/libarmpl_lp64_mp.so 150
    
    update-alternatives --set libblas.so.3-aarch64-linux-gnu ${ARMPL_LIB}/libarmpl_lp64_mp.so
    update-alternatives --set liblapack.so.3-aarch64-linux-gnu ${ARMPL_LIB}/libarmpl_lp64_mp.so
    
    # Add ARMPL to library path
    echo "${ARMPL_LIB}" > /etc/ld.so.conf.d/armpl.conf
    ldconfig
    
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "sessionInfo(); install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc', 'data.table.threads'))"
EOF
ENV OMP_NUM_THREADS=144
ENV OMP_PROC_BIND=close
ENV OMP_PLACES=cores
