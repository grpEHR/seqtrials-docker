FROM rocker/r-ver:4.5.1
RUN echo 'options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/2025-10-24/bin/linux/noble-%s/%s", R.version["arch"], substr(getRversion(), 1, 3))))' > ~/.Rprofile
RUN R -e "install.packages(c('SEQTaRget', 'tidyverse'))"
