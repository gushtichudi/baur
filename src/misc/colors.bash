#!/usr/bin/env bash

print_info() {
  printf ":: \x1b[34m$1\x1b[0m\n"
}

print_success() {
  printf "\x1b[32m$1\x1b[0m\n"
}

print_warning() {
  printf ":: \x1b[33m$1\x1b[0m\n"
}

print_error() {
  printf ":: \x1b[31m$1\x1b[0m\n"
}

die() {
  printf "\x1b[31m$1\x1b[0m\n"
  exit 1
}
