#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)
ROOT_DIR=$(cd $BIN_DIR/../.. && pwd)
APP_DIR=./app

# 環境変数読み込み
source $BIN_DIR/.env

# コンテナー イメージを構築
cd $ROOT_DIR && az acr build \
    --registry "$CONTAINER_REGISTRY_NAME" \
    --image "$CONTAINER_IMAGE_NAME" \
    $APP_DIR
