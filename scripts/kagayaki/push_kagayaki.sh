#!/bin/bash
# ---------------------------------------------------------
# KAGAYAKI 同期・ジョブ投入スクリプト
# ---------------------------------------------------------

# 同じ scripts フォルダ内の .env から設定を読み込む
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# デフォルト設定
REMOTE_HOST="${KAGAYAKI_HOST:-kagayaki}"
JOB_FILE="${KAGAYAKI_JOB_FILE:-scripts/kagayaki/job.pbs}"

# プロジェクトのディレクトリ名を自動取得
PROJECT_NAME=$(basename "$(cd "$(dirname "$0")/../.." && pwd)")
REMOTE_DIR="~/${PROJECT_NAME}"

# 同期から除外
EXCLUDES=("--exclude=.git" "--exclude=__pycache__" "--exclude=.venv" "--exclude=.vscode" "--exclude=.DS_Store")

set -e

echo ">>> 1. KAGAYAKIへファイルを同期しています... [${REMOTE_DIR}]"
# --delete を追加し、ローカルにないファイルはリモートからも削除する
rsync -avz --delete "${EXCLUDES[@]}" "$(dirname "$0")/../../" "${REMOTE_HOST}:${REMOTE_DIR}/"

echo ">>> 2. リモートでジョブ（${JOB_FILE}）を投入しています..."
ssh "${REMOTE_HOST}" "cd ${REMOTE_DIR} && qsub ${JOB_FILE}"

echo ">>> 完了しました。"
