#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

QUEUE_CONNECTION_STRING=`az storage account show-connection-string -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT_NAME --query connectionString --output tsv`


# メッセージをキューに送信
az storage message put \
    --content '{"lat":35.6745,"lon":139.7169}' \
    --queue-name "$QUEUE_NAME" \
    --connection-string "$QUEUE_CONNECTION_STRING"

# ジョブの実行を一覧表示
az containerapp job execution list \
    --name "$JOB_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --output json
