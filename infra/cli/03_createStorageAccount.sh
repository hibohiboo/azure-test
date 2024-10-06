#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# Azure Storage アカウントを作成
az storage account create \
    --name "$STORAGE_ACCOUNT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2

