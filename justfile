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
