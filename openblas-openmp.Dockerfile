FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
RUN <<EOF
    ARCH=$(dpkg --print-architecture)
    apt-get update; apt-get install -y wget time libopenblas-openmp-dev
    cd tmp
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    ALTARCH=$(uname -m)
    update-alternatives --set libblas.so.3-${ALTARCH}-linux-gnu /usr/lib/${ALTARCH}-linux-gnu/openblas-openmp/libblas.so.3
    update-alternatives --set libblas.so-${ALTARCH}-linux-gnu /usr/lib/${ALTARCH}-linux-gnu/openblas-openmp/libblas.so
    update-alternatives --set liblapack.so.3-${ALTARCH}-linux-gnu /usr/lib/${ALTARCH}-linux-gnu/openblas-openmp/liblapack.so.3
    update-alternatives --set liblapack.so-${ALTARCH}-linux-gnu /usr/lib/${ALTARCH}-linux-gnu/openblas-openmp/liblapack.so
    update-alternatives --set libopenblas.so.0-${ALTARCH}-linux-gnu /usr/lib/${ALTARCH}-linux-gnu/openblas-openmp/libopenblas.so.0
    update-alternatives --set libopenblas.so-${ALTARCH}-linux-gnu /usr/lib/${ALTARCH}-linux-gnu/openblas-openmp/libopenblas.so
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc'))"
EOF
