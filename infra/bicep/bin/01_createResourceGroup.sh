#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)
BICEP_DIR=$(cd $BIN_DIR/../biceps && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# リソースグループ作成
cd $BICEP_DIR && az deployment sub create \
  --name rgSubDeployment \
  --location $LOCATION \
  --template-file resourceGroup.bicep \
  --parameters resourceGroupName=$RESOURCE_GROUP resourceGroupLocation=$LOCATION
