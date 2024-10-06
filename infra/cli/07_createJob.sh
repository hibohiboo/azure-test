#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# Container Apps 環境でジョブを作成
az containerapp job create \
    --name "$JOB_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --environment "$ENVIRONMENT" \
    --trigger-type "Event" \
    --replica-timeout "1800" \
    --min-executions "0" \
    --max-executions "10" \
    --polling-interval "60" \
    --scale-rule-name "queue" \
    --scale-rule-type "azure-queue" \
    --scale-rule-metadata "accountName=$STORAGE_ACCOUNT_NAME" "queueName=$QUEUE_NAME" "queueLength=1" \
    --scale-rule-auth "connection=connection-string-secret" \
    --image "$CONTAINER_REGISTRY_NAME.azurecr.io/$CONTAINER_IMAGE_NAME" \
    --cpu "0.5" \
    --memory "1Gi" \
    --secrets "connection-string-secret=$QUEUE_CONNECTION_STRING" \
    --registry-server "$CONTAINER_REGISTRY_NAME.azurecr.io" \
    --env-vars "AZURE_STORAGE_QUEUE_NAME=$QUEUE_NAME" "AZURE_STORAGE_CONNECTION_STRING=secretref:connection-string-secret"
