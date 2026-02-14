#!/bin/bash

print_header() { echo -e "\n\033[1;36m$1\033[0m"; }
print_success() { echo -e "\033[1;32m$1\033[0m"; }
print_error() { echo -e "\033[1;31m$1\033[0m" >&2; }
print_step() { echo -e "\033[1;34m→ $1\033[0m"; }
