#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)
BICEP_DIR=$(cd $BIN_DIR/../biceps && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# Azure Storage アカウントを作成
# メッセージ キューを作成
cd $BICEP_DIR/core/storage && az deployment group create \
  --name 03_04_createStorageAccount \
  --template-file blobContainerAndQueue.bicep \
  --parameters \
    storageAccountName=$STORAGE_ACCOUNT_NAME \
    queueName=$QUEUE_NAME \
  -g $RESOURCE_GROUP


