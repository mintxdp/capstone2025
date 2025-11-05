#!/usr/bin/env bash

confirm() {
  read -rp "$1 [y/N]: " response
  [[ "$response" =~ ^[Yy]$ ]]
}

