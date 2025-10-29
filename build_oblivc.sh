#!/usr/bin/env bash
set -e
set -o pipefail

timestamp=$(date +"%Y%m%d_%H%M%S")
logfile="build_$timestamp.log"
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

OUTPUT_DIR=$(pwd)/output
mkdir -p "$OUTPUT_DIR"
# Ghi log mọi thứ (stdout + stderr) từ toàn bộ script
exec > >(tee -a "$OUTPUT_DIR/$logfile") 2>&1

IMAGE_NAME=oblivc-builder

log "==========================================="
log "🚀 STARTING BUILD: $timestamp"
log "==========================================="

docker build -t "$IMAGE_NAME" .
# docker build -t $IMAGE_NAME . 2>&1 | tee $OUTPUT_DIR/$logfile

log "📁 Ensuring output directory exists...  $OUTPUT_DIR"

log "🏗️ Running build container and exporting /obliv-c to host..."
docker run --rm \
  --name $IMAGE_NAME-crun \
#  -v $(pwd):/obliv-c \
  $IMAGE_NAME
log "Build completed! Files available in: $OUTPUT_DIR"
