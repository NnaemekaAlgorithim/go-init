#!/bin/bash

require_command() {
  if ! command -v "$1" &> /dev/null; then
    print_error "Missing required tool: $1"
    exit 1
  fi
}
