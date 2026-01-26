FROM rocker/r-ver:4.5.2
ARG CRAN_DATE=2025-01-26
ARG QUARTO_VERSION=1.8.27
RUN <<EOF
    ARCH=$(dpkg --print-architecture)
    apt-get update -y; apt-get upgrade -y; apt-get install wget time # pkg-config libcurl4-openssl-dev libxml2-dev zlib1g-dev libfontconfig1-dev libssl-dev
    cd tmp
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc', 'data.table.threads'))"
EOF
