build:
    docker build --platform linux/amd64 --tag seqtrials .
mpbuild:
    docker buildx build --pull --platform linux/arm64,linux/amd64 --tag seqtrials .
run:
    docker run -it --rm seqtrials
bash:
    docker run -it --rm seqtrials bash
armbuild:
    docker build --platform linux/arm64 --tag seqtrials .
publish version:
    docker tag seqtrials remlapmot/seqtrials:{{ version }}
    docker push remlapmot/seqtrials:{{ version }}
test:
    docker run --platform linux/amd64 --rm -v $PWD:/home seqtrials bash /home/tests.sh
    docker run --platform linux/arm64 --rm -v $PWD:/home seqtrials bash /home/tests.sh
nvplbuild:
    docker build --pull --platform linux/arm64 --tag seqtrials --file nvpl.Dockerfile .
ompbuild:
    docker build --pull --platform linux/arm64 --tag seqtrials --file openblas-openmp.Dockerfile .
mklbuild:
    docker build --pull --platform linux/amd64 --tag seqtrials --file mkl.Dockerfile .
armplbuild:
    docker build --pull --platform linux/arm64 --tag seqtrials --file armpl.Dockerfile .
