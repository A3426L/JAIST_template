#!/bin/bash
# ---------------------------------------------------------
# KAGAYAKI 同期・ジョブ投入スクリプト
# ---------------------------------------------------------

# 設定読み込み
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then source "$ENV_FILE"; fi

REMOTE_HOST="${KAGAYAKI_HOST:-kagayaki}"
JOB_FILE="${KAGAYAKI_JOB_FILE:-scripts/kagayaki/job.pbs}"

PROJECT_NAME=$(basename "$(cd "$(dirname "$0")/../.." && pwd)")
REMOTE_DIR="~/${PROJECT_NAME}"

set -e

echo ">>> 1. KAGAYAKIへファイルを同期しています... [${REMOTE_DIR}]"
# --filter=':- .gitignore' を追加することで、.gitignoreの内容を同期から除外します
rsync -avz --delete --filter=':- .gitignore' "$(dirname "$0")/../../" "${REMOTE_HOST}:${REMOTE_DIR}/"

echo ">>> 2. リモートでジョブ（${JOB_FILE}）を投入しています..."
ssh "${REMOTE_HOST}" "cd ${REMOTE_DIR} && qsub ${JOB_FILE}"

echo ">>> 完了しました。"
