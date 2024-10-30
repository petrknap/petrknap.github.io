#!/usr/bin/env bash
DIR="$(realpath "${BASH_SOURCE%/*}")"

docker run --rm -ti \
           -v "${DIR}/..:/srv/jekyll" \
           -p 4000:4000 \
           --tmpfs "/srv/jekyll/.jekyll-cache" \
           --tmpfs "/srv/jekyll/_site" \
           "petrknap.github.io:latest" \
           jekyll "$@"
