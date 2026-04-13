#!/bin/bash
# ---------------------------------------------------------
# KIELI (Ubuntu) 同期・実行スクリプト
# ---------------------------------------------------------

# 同じ scripts フォルダ内の .env から設定を読み込む
ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# デフォルト設定
REMOTE_HOST="${KIELI_HOST:-kieli}"
RUN_SCRIPT="scripts/kieli/run_remote.sh"

# プロジェクトのディレクトリ名を自動取得
PROJECT_NAME=$(basename "$(cd "$(dirname "$0")/../.." && pwd)")
REMOTE_DIR="~/${PROJECT_NAME}"

# 同期から除外
# data/ checkpoints/ log/ はリモートで生成されるため --delete の対象から外す
EXCLUDES=("--exclude=.git" "--exclude=__pycache__" "--exclude=.venv" "--exclude=.vscode" "--exclude=.DS_Store" "--exclude=data/" "--exclude=checkpoints/" "--exclude=log/")

set -e

echo ">>> 1. KIELI (Ubuntu) へファイルを同期しています... [${REMOTE_DIR}]"
# --delete を追加し、ローカルにないファイルはリモートからも削除する
rsync -avz --delete "${EXCLUDES[@]}" "$(dirname "$0")/../../" "${REMOTE_HOST}:${REMOTE_DIR}/"

echo ">>> 2. リモートで実行を開始します..."
ssh "${REMOTE_HOST}" "cd ${REMOTE_DIR} && chmod +x ${RUN_SCRIPT} && ./${RUN_SCRIPT}"

echo ">>> 完了しました。"
