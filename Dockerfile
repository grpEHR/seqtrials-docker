FROM rocker/r-ver:4.5.2
RUN <<EOF
    apt-get update; apt-get install wget
    cd tmp
    ARCH=$(dpkg --print-architecture)
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.25/quarto-1.8.25-linux-${ARCH}.deb
    dpkg -i quarto-1.8.25-linux-${ARCH}.deb
EOF
RUN echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/2025-11-07/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
RUN R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto'))"
