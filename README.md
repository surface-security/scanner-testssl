# Security Scanner in Docker

## Run locally
- Build: `docker build -t ${PWD##*/} .`
- Create `/tmp/input/input.txt` and `/tmp/output`.
- Run: `docker run -it --rm -v /tmp/input:/input -v /tmp/output:/output ${PWD##*/}:latest`

## Parameters
- Run Docker with `--help` as parameter.
