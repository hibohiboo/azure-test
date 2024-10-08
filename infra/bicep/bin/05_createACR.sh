#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)
BICEP_DIR=$(cd $BIN_DIR/../biceps && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# コンテナー レジストリを作成
cd $BICEP_DIR/core/containerApps && az deployment group create \
  --name functionsDeployment \
  --template-file azureContainerRegistry.bicep \
  --parameters \
    acrName=$CONTAINER_REGISTRY_NAME \
  -g $RESOURCE_GROUP


