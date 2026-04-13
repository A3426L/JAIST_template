#!/bin/bash
# ---------------------------------------------------------
# HAKUSAN 同期・ジョブ投入スクリプト
# ---------------------------------------------------------

# 設定読み込み
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then source "$ENV_FILE"; fi

REMOTE_HOST="${HAKUSAN_HOST:-hakusan}"
JOB_FILE="${HAKUSAN_JOB_FILE:-scripts/hakusan/job.pbs}"

PROJECT_NAME=$(basename "$(cd "$(dirname "$0")/../.." && pwd)")
REMOTE_DIR="~/${PROJECT_NAME}"

# 同期から除外
# data/ と checkpoints/ はリモートで生成されるため --delete の対象から外す
EXCLUDES=("--exclude=.git" "--exclude=__pycache__" "--exclude=.venv" "--exclude=.vscode" "--exclude=.DS_Store" "--exclude=data/" "--exclude=checkpoints/")

set -e

echo ">>> 1. HAKUSANへファイルを同期しています... [${REMOTE_DIR}]"
rsync -avz --delete "${EXCLUDES[@]}" "$(dirname "$0")/../../" "${REMOTE_HOST}:${REMOTE_DIR}/"

echo ">>> 2. リモートでジョブ（${JOB_FILE}）を投入しています..."
ssh "${REMOTE_HOST}" "cd ${REMOTE_DIR} && sbatch ${JOB_FILE}"

echo ">>> 完了しました。"
