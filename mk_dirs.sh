#!/bin/bash

if [[ ! -d target ]]; then
    mkdir target
fi

if [[ ! -d target/the-system ]]; then
    mkdir -p target/the-system/debug
    mkdir -p target/the-system/release
fi

if [[ ! -d target/the-system-cli ]]; then
    mkdir -p target/the-system-cli/debug
    mkdir -p target/the-system-cli/release
fi

if [[ ! -d target/utils ]]; then
    mkdir -p target/utils/debug
    mkdir -p target/utils/release
fi
