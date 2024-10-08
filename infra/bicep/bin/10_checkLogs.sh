#!/bin/bash

# ディレクトリパス取得
BIN_DIR=$(cd $(dirname $0) && pwd)

# 環境変数読み込み
source $BIN_DIR/.env

# ジョブの実行を一覧表示
LOG_ANALYTICS_WORKSPACE_ID=`az containerapp env show --name $ENVIRONMENT --resource-group $RESOURCE_GROUP --query properties.appLogsConfiguration.logAnalyticsConfiguration.customerId --out tsv`

# ログメッセージを確認
az monitor log-analytics query \
    --workspace "$LOG_ANALYTICS_WORKSPACE_ID" \
    --analytics-query "ContainerAppConsoleLogs_CL | where ContainerJobName_s == '$JOB_NAME' | order by _timestamp_d asc"

