#!/bin/bash

set -e

cd "$(dirname "$(realpath -s "$0")")/$1"

docker-compose down -v

