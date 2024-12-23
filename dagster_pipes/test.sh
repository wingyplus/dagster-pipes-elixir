#!/usr/bin/env bash

echo 
path=$(dirname $(realpath $0))
mix cmd --cd ${path} mix run test/test.exs "$@"
