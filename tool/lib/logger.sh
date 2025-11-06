#!/usr/bin/env bash

LOG_DIR="/var/log/tool"
INFO_LOG="$LOG_DIR/info.log"
ERROR_LOG="$LOG_DIR/error.log"

mkdir -p "$LOG_DIR" 2>/dev/null

log_info() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $*" | tee -a "$INFO_LOG"
}

log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] $*" | tee -a "$ERROR_LOG" >&2
}
  
