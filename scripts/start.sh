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

echo "Ensuring default tenant exists..."
$BIN tenants ensure-default \
  --default-tenant-owner-email "${DEFAULT_TENANT_OWNER_EMAIL:-owner@default.local}" \
  --default-tenant-owner-first-name "${DEFAULT_TENANT_OWNER_FIRST_NAME:-Default}" \
  --default-tenant-owner-last-name "${DEFAULT_TENANT_OWNER_LAST_NAME:-Owner}" \
  --default-tenant-distribution-account-type "${DEFAULT_TENANT_DISTRIBUTION_ACCOUNT_TYPE:-DISTRIBUTION_ACCOUNT.STELLAR.ENV}" \
  --sdp-ui-base-url "${SDP_UI_BASE_URL:-$BASE_URL}"

echo "Starting server..."
exec $BIN serve
