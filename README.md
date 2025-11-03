# Docker container with R and sequential trials related R packages

To build, install

* [Docker by installing Docker Desktop on Windows and macOS](https://docs.docker.com/get-started/get-docker/)
* [just](https://github.com/casey/just?tab=readme-ov-file#packages)

(ensuring binaries are on `PATH`)

And run 

```sh
just build
```

For the multi-architecture build run

```sh
just mpbuild
```

and to test

```sh
just test
```

## Possible additional packages to add/compare

* [TrialEmulation](https://cran.r-project.org/package=TrialEmulation)
* [debiasedTrialEmulation](https://cran.r-project.org/package=debiasedTrialEmulation)
