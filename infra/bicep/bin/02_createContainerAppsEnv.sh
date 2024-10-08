#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)
BICEP_DIR=$(cd $BIN_DIR/../biceps && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# Container Apps 環境を作成
cd $BICEP_DIR/core/containerApps && az deployment group create \
  --name functionsDeployment \
  --template-file containerApps.bicep \
  --parameters \
    environmentName=$ENVIRONMENT \
  -g $RESOURCE_GROUP

