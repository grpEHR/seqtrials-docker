FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
RUN <<EOF
    ARCH=$(dpkg --print-architecture)
    apt-get update; apt-get install wget time curl tee
    cd tmp
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc'))"
EOF
RUN <<EOF

    # https://developer.arm.com/documentation/109681/25071/Get-started/Download-and-installation-using-System-Packages/Ubuntu-Linux-22-04-and-24-04
    
    apt-get update
    
    . /etc/os-release
    curl "https://developer.arm.com/packages/arm-toolchains:${NAME,,}-${VERSION_ID/%.*/}/${VERSION_CODENAME}/Release.key" | tee /etc/apt/trusted.gpg.d/developer-arm-com.asc
    echo "deb https://developer.arm.com/packages/arm-toolchains:${NAME,,}-${VERSION_ID/%.*/}/${VERSION_CODENAME}/ ./" | tee /etc/apt/sources.list.d/developer-arm-com.list
    apt-get update; apt-get install arm-performance-libraries
    
EOF

# update-alternatives --install \
  # /usr/lib/aarch64-linux-gnu/libblas.so.3 \
  # libblas.so.3-aarch64-linux-gnu \
  # /usr/lib/aarch64-linux-gnu/libmkl_rt.so 150

# update-alternatives --set libblas.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libmkl_rt.so

# update-alternatives --install \
  # /usr/lib/aarch64-linux-gnu/liblapack.so.3 \
  # liblapack.so.3-aarch64-linux-gnu \
  # /usr/lib/aarch64-linux-gnu/libmkl_rt.so 150

# update-alternatives --set liblapack.so.3-aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/libmkl_rt.so
