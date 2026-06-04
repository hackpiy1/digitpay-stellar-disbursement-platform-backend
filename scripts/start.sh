#!/bin/sh
# //
set -e

BIN="./stellar-disbursement-platform"

echo "Running admin migrations..."
$BIN db admin migrate up

echo "Running TSS migrations..."
$BIN db tss migrate up

echo "Running auth migrations..."
$BIN db auth migrate up --all

echo "Running SDP migrations..."
$BIN db sdp migrate up --all

echo "Setting up assets and wallets for network..."
$BIN db setup-for-network --all

echo "Starting server..."
exec $BIN serve
