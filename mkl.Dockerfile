FROM rocker/r-ver:4.5.2
ARG QUARTO_VERSION=1.8.26
ARG CRAN_DATE=2025-12-22
RUN <<EOF
    ARCH=$(dpkg --print-architecture)
    apt-get update; apt-get install wget time
    cd tmp
    wget -nv https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    dpkg -i quarto-${QUARTO_VERSION}-linux-${ARCH}.deb
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
    R -e "install.packages(c('SEQTaRget', 'tidyverse', 'quarto', 'tictoc'))"
EOF
RUN <<EOF
    apt-get update; apt-get -y install intel-mkl
    
    update-alternatives --install \
      /usr/lib/x86_64-linux-gnu/libblas.so.3 \
      libblas.so.3-aarch64-linux-gnu \
      /usr/lib/x86_64-linux-gnu/libmkl_rt.so 150
    
    update-alternatives --set libblas.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/libmkl_rt.so
    
    update-alternatives --install \
      /usr/lib/aarch64-linux-gnu/liblapack.so.3 \
      liblapack.so.3-x86_64-linux-gnu \
      /usr/lib/x86_64-linux-gnu/libmkl_rt.so 150
    
    update-alternatives --set liblapack.so.3-x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/libmkl_rt.so
EOF
RUN <<EOF
    # Recompile R packages
    rm ~/.Rprofile
    echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/'"${CRAN_DATE}"'")))' > ~/.Rprofile
    # R core packages
    R -e "getOption('repos'); install.packages(unname(installed.packages(lib.loc = .libPaths()[2])[, 'Package']), type = 'source')"
    # Additional packages
    R -e "getOption('repos'); install.packages(unname(installed.packages(lib.loc = .libPaths()[1])[, 'Package']), type = 'source')"
EOF
