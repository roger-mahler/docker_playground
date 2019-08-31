#!/bin/bash

# Set up required pass-through variables.
user=${USER-$(whoami)}
cmd="run"

if [ "$cmd" == "run" ]; then
    # Run the container with the current and home directories mounted.
    docker run -it --rm --mount "type=bind,src=$(pwd),dst=/home/data" hfst-swener "$@"
fi

if [ "$cmd" == "extract-tagged-names" ]; then
    docker run -it --rm --entrypoint "extract-tagged-names.py" --mount "type=bind,src=$(pwd),dst=/home/data" hfst-swener "$@"
fi
