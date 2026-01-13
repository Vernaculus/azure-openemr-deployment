#!/bin/bash
# Securely prompt for service principal credentials

echo "Enter Service Principal credentials (input hidden):"

read -p "ARM_CLIENT_ID: " ARM_CLIENT_ID
echo
read -sp "ARM_CLIENT_SECRET: " ARM_CLIENT_SECRET
echo
read -p "ARM_TENANT_ID: " ARM_TENANT_ID
echo
read -p "ARM_SUBSCRIPTION_ID: " ARM_SUBSCRIPTION_ID
echo

export ARM_CLIENT_ID
export ARM_CLIENT_SECRET
export ARM_TENANT_ID
export ARM_SUBSCRIPTION_ID

echo "✓ Credentials set as environment variables for this session"
