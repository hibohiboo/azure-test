#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# リソースグループ作成
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION"
