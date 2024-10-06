#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# 接続文字列を変数に保存
QUEUE_CONNECTION_STRING=`az storage account show-connection-string -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT_NAME --query connectionString --output tsv`

# メッセージ キューを作成
az storage queue create \
    --name "$QUEUE_NAME" \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --connection-string "$QUEUE_CONNECTION_STRING"

echo $QUEUE_CONNECTION_STRING
