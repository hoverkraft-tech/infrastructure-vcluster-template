#!/bin/bash

set -eu -o pipefail

FILE="${1}"
TIMEOUT="${2:-300}"
INTERVAL="${3:-5}"

if [ -z "$FILE" ]; then
  echo "Usage: wait-for-file.sh <file> [timeout] [interval]"
  exit 1
fi

while [ ! -f "$FILE" ] && [ $TIMEOUT -gt 0 ]; do
  echo "Waiting for $FILE... ($TIMEOUTs remaining)"
  sleep $INTERVAL
  TIMEOUT=$((TIMEOUT - $INTERVAL))
done

if [ ! -f "$FILE" ]; then
  echo "ERROR: File $FILE not found after $TIMEOUT seconds"
  exit 1
fi

echo "File $FILE found!"
exit 0
