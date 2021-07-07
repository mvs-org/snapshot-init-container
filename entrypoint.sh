#!/bin/bash

set -e

unarchive_7z() {
    echo "Unarchiving (7zip)..."
    7z x "$1" -o$2
}

unarchive_zstd() {
    echo "Unarchiving (zstd)..."
    tar xv --zstd -f "$1" -C "$2"
}

unarchive_gzip() {
    echo "Unarchiving (gzip)..."
    tar xvzf "$1" -C "$2"
}

if [ -z "$ARCHIVE_URL" ]; then
    echo "No archive download url specified, exiting"
    exit 0
fi

CHAIN_DB_PATH=$CHAIN_DIR/db

if [ "$(ls -A "$CHAIN_DB_PATH" 2>/dev/null)" ]; then
    echo "Chain database $CHAIN_DB_PATH already exists, exiting"
    exit 0
else
    echo "No chain database files in $CHAIN_DB_PATH, initializing..."
fi

if [[ "$ARCHIVE_URL" == *.7z ]]; then
    unarchive_func=unarchive_7z
elif [[ "$ARCHIVE_URL" == *.tar.zst ]]; then
    unarchive_func=unarchive_zstd
elif [[ "$ARCHIVE_URL" == *.tar.gz ]]; then
    unarchive_func=unarchive_gzip
else
    echo "Unsupported archive file type $ARCHIVE_URL"
    exit 1
fi

if [ -z "$CHAIN_DIR" ]; then
    echo 'Environment variable $CHAIN_DIR should not be empty'
    exit 1
    #
    # With the chain node CLI option --base=/data, $CHAIN_DIR examples:
    #


echo "Downloading $ARCHIVE_URL..."
mkdir -p /snapshot
wget -c --progress dot:giga -O /snapshot/archive.tmp "$ARCHIVE_URL"

mkdir -p "$CHAIN_DB_PATH"
$unarchive_func /snapshot/archive.tmp "$CHAIN_DIR"

if [ -n "$CHOWN" ]; then
    echo "Chown to $CHOWN..."
    chown -R "$CHOWN" "$CHAIN_DIR"
fi

if [ -n "$CHMOD" ]; then
    echo "Chmod to $CHMOD..."
    chmod -R "$CHMOD" "$CHAIN_DIR"
fi

echo "Cleaning up..."
rm -v /snapshot/archive.tmp

echo
ls -la $CHAIN_DB_PATH
