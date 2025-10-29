build:
    docker build --platform linux/amd64 --tag seqtrials .
run:
    docker run -it seqtrials
bash:
    docker run -it seqtrials bash
armbuild:
    docker build --platform linux/arm64 --tag seqtrials .
