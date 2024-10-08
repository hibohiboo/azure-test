#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)
BICEP_DIR=$(cd $BIN_DIR/../biceps && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# 接続文字列を変数に保存
QUEUE_CONNECTION_STRING=`az storage account show-connection-string -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT_NAME --query connectionString --output tsv`

# コンテナー レジストリを作成
cd $BICEP_DIR/core/containerApps && az deployment group create \
  --name 07_createJob \
  --template-file containerJob.bicep \
  --parameters \
    acrName=$CONTAINER_REGISTRY_NAME \
    jobName=$JOB_NAME \
    containerImageName=$CONTAINER_IMAGE_NAME \
    storageAccountName=$STORAGE_ACCOUNT_NAME \
    queueName=$QUEUE_NAME \
    environmentName=$ENVIRONMENT \
  -g $RESOURCE_GROUP


